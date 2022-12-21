const mongoose = require('mongoose');

// set user model

var imageSchema = new mongoose.Schema({
    name: {
        required: true,
        type: String, 
    },
    url: {
        required: true,
        type: String,
    }

});
 
//Image is a model which has a schema imageSchema
const Image2 = mongoose.model("Image2", imageSchema);
module.exports = Image2; // allow public access