const path = require('path');

module.exports = {
  mode: 'development', // または 'production'
  entry: './app/javascript/packs/application.js', // プロジェクトのエントリーポイントに合わせて変更
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'public', 'packs')
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env']
          }
        }
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      },
      {
        test: /\.(scss|sass)$/,
        use: ['style-loader', 'css-loader', 'sass-loader']
      }
    ]
  },
  node: {
    __dirname: true,
    __filename: true,
    global: true
  }
};
