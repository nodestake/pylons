const functions = require('@google-cloud/functions-framework');
var bodyParser = require('body-parser')
const { IncomingWebhook } = require('@slack/webhook');
const url = process.env.SLACK_WEBHOOK_URL;

const webhook = new IncomingWebhook(url);


module.exports = functions.http('discordAlerts', (request, response) => {
  let error = JSON.parse(request.body);
  json = bodyParser.raw(request.body)
  console.log(error)
  
  // const tag = request.body.queryResult.intent

  // let jsonResponse = {};
    //fulfillment response to be sent to the agent if the request tag is equal to "welcome tag"
  // errAlert = parseEvent(request.data)
  message = createDiscordMessage(error)
  webhook.send(message);
  response.end()


});

const createDiscordMessage = (error) => {
  var embeds = []
  let message = {
    text: "GCP Alerts",
    mrkdwn: true,
    attachments: [
      {
        title: error.incident.condition.displayName,
        title_link: error.incident.url,
        fields: [{
        title: error.exception_info.state,
        value: error.incident.summary
      }]
  }
]
};
embeds.push({
  title: "test",
  description: error})

  
message.embeds = embeds;
return message;
}


// subscribeSlack is the main function called by Cloud Functions.
// module.exports.subscribeSlack = (pubSubEvent, context) => {
//   // const build = eventToBuild(pubSubEvent.data);
//  // const alert = eventToError(pubSubEvent.data)
//   console.log("DATA: " + pubSubEvent.data);

//   // Skip if the current status is not in the status list.
//   // Add additional statuses to list if you'd like:
//   // QUEUED, WORKING, SUCCESS, FAILURE,
//   // INTERNAL_ERROR, TIMEOUT, CANCELLED
//   // const status = ['SUCCESS', 'FAILURE', 'INTERNAL_ERROR', 'TIMEOUT'];
//   // if (status.indexOf(build.status) === -1) {
//   //   return;
//   // }

//   // Send message to Slack.
//   event = parseEvent(pubSubEvent.data)
//   const message = createDiscordMessage();
//   //const message = createSlackMessage(build);
//   webhook.send(message);
// };


// eventToBuild transforms pubsub event message to a build object.
const parseEvent = (data) => {
  return JSON.parse(Buffer.from(data, 'base64').toString());
}

// const eventToError = (data) => {
//   return JSON.parse(Buffer.from(data, 'base64').toString())
// }




// // createSlackMessage create a message from a build object.
// const createSlackMessage = (build) => {
//   var embeds = []
// let repoName = build.substitutions.REPO_NAME
//   let message = {
//    text: repoName,
//     mrkdwn: true,
//     attachments: [
//       {
//         title: build.name,
//         title_link: build.logUrl,
//         fields: [{
//           title: 'Status',
//           value: build.status
//         }]
//       }
//     ]
//   };
//       if (build && build.steps) {
//         build.steps.forEach(function (step) {
//             var time = '';
//             if (step.timing && step.timing.endTime) {
//                 time = "took " + (new Date(step.timing.endTime) - new Date(step.timing.startTime)) * .001;
//             }
//             embeds.push({
//                 title: step.name,
//                 description: step.entrypoint + " " + step.args.join(' ') + " " + time + " and " + step.status,
//                 color: build.status === 'FAILURE' ? 16714507 : 6618931
//             });
//         });
//         message.embeds = embeds;
//     }
//   return message
// }