const express = require("express");
const { Kafka } = require("kafkajs");

const app = express();
app.use(express.json());

const kafka = new Kafka({ brokers: ["172.20.160.1:9092"] });
const producer = kafka.producer();

app.post("/send", async (req, res) => {
  try {
    const { topic, message } = req.body;

    if (!topic || !message) {
      return res.status(400).send("Topic and message are required.");
    }

    await producer.connect();
    await producer.send({
      topic,
      messages: [{ value: message }],
    });

    await producer.disconnect();
    res.send("Message sent to topic: ${topic}");
  } catch (error) {
    console.log(error);
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Producer API listening on port ${PORT}`));
