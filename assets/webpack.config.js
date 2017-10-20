const path = require('path');

module.exports = {

  entry: './js/app',
  output: {
    path: path.resolve(__dirname, '../priv/static'),
    filename: 'js/app.js'
  },

  module: {
    rules: [{
      test: /\.js$/,
      exclude: [/node_modules/, /priv\/static/],
      use: {
        loader: 'babel-loader',
        options: {
          presets: ['env']
        }
      }
    }]
  }

};
