const GREETINGS = [
  "Whalecome!",
  "Is it that time of the year!",
  "Charting the course ahead!",
];

module.exports = async (req, res) => {
  res.send({
    greeting: GREETINGS[Math.floor(Math.random() * GREETINGS.length)],
  });
};