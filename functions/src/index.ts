import {onCall, HttpsError} from "firebase-functions/v2/https";
import {google} from "googleapis";
import * as logger from "firebase-functions/logger";
import {SecretManagerServiceClient} from "@google-cloud/secret-manager";

// Defines the structure of the data sent from the Flutter app.
interface RequestData {
  text: string;
  sessionId: string;
}

/**
 * Fetches a service account key from Secret Manager and uses it to create an
 * authenticated Dialogflow client. This is the most secure method.
 * @return {Promise<any>} An authenticated Dialogflow client instance.
 */
async function getAuthenticatedDialogflowClient() {
  const secretManager = new SecretManagerServiceClient();
  const projectId = process.env.GCLOUD_PROJECT;

  if (!projectId) {
    logger.error("GCLOUD_PROJECT environment variable not set.");
    throw new Error("Project ID not found.");
  }
  
  // This must match the name of the secret you created in Secret Manager.
  const secretName = `projects/${projectId}/secrets/dialogflow-key/versions/latest`;

  // Access the secret's value.
  const [version] = await secretManager.accessSecretVersion({name: secretName});
  const credentialsJson = version.payload?.data?.toString();

  if (!credentialsJson) {
    logger.error("Could not retrieve credentials from Secret Manager.");
    throw new Error("Credentials not found in Secret Manager.");
  }

  // Create an authentication client using the key from the secret.
  const auth = new google.auth.GoogleAuth({
    credentials: JSON.parse(credentialsJson),
    scopes: ["https://www.googleapis.com/auth/cloud-platform"],
  });
  
  const authClient = await auth.getClient();
  
  // Return a Dialogflow client authenticated with our key.
  // We use `as any` here as a safe workaround for a known type
  // incompatibility issue between Google's own libraries.
  return google.dialogflow({version: "v2", auth: authClient as any});
}

/**
 * A Firebase Callable Function that receives a message from the app,
 * sends it to Dialogflow, and returns the response.
 */
export const getLumiResponse = onCall<RequestData>(async (request) => {
  // Ensure the user calling the function is authenticated with Firebase Auth.
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "The function must be called while authenticated.",
    );
  }
  
  const projectId = process.env.GCLOUD_PROJECT;
  const text = request.data.text;
  const sessionId = request.data.sessionId;

  if (!projectId || !text || !sessionId) {
    throw new HttpsError("invalid-argument", "Missing required parameters.");
  }

  const sessionPath = `projects/${projectId}/agent/sessions/${sessionId}`;
  const dialogflowRequest = {
    session: sessionPath,
    queryInput: {
      text: {text: text, languageCode: "en-US"},
    },
  };

  try {
    // Get our explicitly authenticated Dialogflow client.
    const dialogflow = await getAuthenticatedDialogflowClient();
    
    const response =
      await dialogflow.projects.agent.sessions.detectIntent(dialogflowRequest);
    const result = response.data.queryResult;
    return {text: result?.fulfillmentText};

  } catch (error) {
    logger.error("Dialogflow API Error:", error);
    throw new HttpsError("internal", "Error calling Dialogflow API.");
  }
});