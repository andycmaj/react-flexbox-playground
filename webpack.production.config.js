var path = require('path');
var webpack = require('webpack');

module.exports = {
  entry: {
    app: ['./src/scripts/init'],
  },
  devtool: 'source-map',
  output: {
      path: path.join(__dirname, "build"),
      filename: "bundle.js",
  },
  resolveLoader: {
    modulesDirectories: ['..', 'node_modules']
  },
  plugins: [
    new webpack.DefinePlugin({
      // This has effect on the react lib size.
      "process.env": {
        NODE_ENV: JSON.stringify("production")
      }
    }),
    new webpack.IgnorePlugin(/vertx/),
    new webpack.IgnorePlugin(/un~$/),
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.UglifyJsPlugin(),
  ],
  resolve: {
    extensions: ['', '.js', '.cjsx', '.coffee']
  },
  module: {
    loaders: [
      { test: /\.less$/, loader: 'style-loader!css-loader!less-loader'},
      { test: /\.cjsx$/, loaders: ['coffee', 'cjsx']},
      { test: /\.coffee$/, loader: 'coffee' },

      { test: /\.woff($|\?)/,   loader: "url-loader?prefix=font/&limit=5000&mimetype=application/font-woff" },
      { test: /\.ttf($|\?)/,    loader: "file-loader" },
      { test: /\.eot($|\?)/,    loader: "file-loader" },
      { test: /\.svg($|\?)/,    loader: "file-loader" }
    ]
  }
};
