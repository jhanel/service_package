import express from 'express';
import multer from 'multer';

const express = require('express');
const multer = require('multer');
const app = express();
const upload = multer({ dest: 'uploads/' });

app.post('/upload', upload.single('file'), (req, res) => {
  res.status(200).send('File uploaded successfully');
});

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
