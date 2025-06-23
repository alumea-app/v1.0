// Import from the v2 SDK
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {google} from "googleapis";
import * as logger from "firebase-functions/logger";

// Define an interface for the data property for strong typing
interface RequestData {
  text: string;
  sessionId: string;
}

// Initialize the Dialogflow client
const dialogflow = google.dialogflow("v2");

// Use onCall<RequestData> to get a strongly-typed request object
export const getLumiResponse = onCall<RequestData>(async (request) => {
  // 1. In v2, auth info is on the 'auth' property of the request object.
  if (!request.auth) {
    // Use HttpsError from the v2 import
    throw new HttpsError(
      "unauthenticated",
      "The function must be called while authenticated.",
    );
  }

  // 2. In v2, the data sent from the client is on the 'data' property.
  const text = request.data.text;
  const sessionId = request.data.sessionId;
  const projectId = process.env.GCLOUD_PROJECT;

  if (!text || !sessionId) {
    throw new HttpsError(
      "invalid-argument",
      "The function must be called with 'text' and 'sessionId' arguments.",
    );
  }

  const sessionPath = `projects/${projectId}/agent/sessions/${sessionId}`;
  const dialogflowRequest = {
    session: sessionPath,
    queryInput: {
      text: {
        text: text,
        languageCode: "en-US",
      },
    },
  };

  try {
    const response =
      await dialogflow.projects.agent.sessions.detectIntent(dialogflowRequest);
    const result = response.data.queryResult;

    return {text: result?.fulfillmentText};
  } catch (error) {
    // Use the new logger for better logging
    logger.error("Dialogflow API Error:", error);
    throw new HttpsError(
      "internal",
      "Error calling Dialogflow API.",
    );
  }
});
