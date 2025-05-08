const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

// Replace with your MongoDB URI
const uri = " mongodb+srv://codebuddy:code3464@cluster0.e0n2hxd.mongodb.net/flutterdb?retryWrites=true&w=majority&appName=Cluster0
";
mongoose.connect(uri)
  .then(() => console.log("MongoDB connected"))
  .catch(err => console.log(err));

// Define a schema and model
const ItemSchema = new mongoose.Schema({ name: String });
const Item = mongoose.model('Item', ItemSchema);

// Routes
app.get('/items', async (req, res) => {
  const items = await Item.find();
  res.json(items);
});

app.post('/items', async (req, res) => {
  const item = new Item({ name: req.body.name });
  await item.save();
  res.json(item);
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server started on port ${PORT}`));

