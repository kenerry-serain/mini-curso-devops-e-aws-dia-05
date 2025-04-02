const express = require("express");
const { Kafka } = require("kafkajs");

const app = express();
const kafka = new Kafka({ brokers: ["172.20.200.127:9092"] });
const consumer = kafka.consumer({ groupId: "my-group" });

let currentTopic = null;

// Function to initialize consumer and subscribe to the topic
async function initializeConsumer(topic) {
  await consumer.connect();
  
  if (topic) {
    // Subscribe to the topic **before** running the consumer
    await consumer.subscribe({ topic, fromBeginning: true });
  }
  
  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      console.log(`Received message: ${message.value.toString()} from topic: ${topic}`);
    },
  });
}

// Route to start consuming messages from a specified topic
app.get("/consume", async (req, res) => {
  try {
    const { topic } = req.query;

    if (!topic) {
      return res.status(400).send("Topic is required.");
    }

    // If the consumer is already running, prevent resubscription
    if (currentTopic === topic) {
      return res.status(400).send(`Already consuming from topic: ${topic}`);
    }

    // Stop the consumer if it's running (this is an optional step, based on your use case)
    if (currentTopic !== null) {
      await consumer.disconnect();
    }

    // Set the new topic and initialize the consumer
    currentTopic = topic;
    await initializeConsumer(topic);

    res.send(`Started consuming from topic: ${topic}`);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error while consuming messages.");
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Consumer API listening on port ${PORT}`));
