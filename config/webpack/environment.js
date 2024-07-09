const { environment } = require('@rails/webpacker')
const { resolve } = require('path')

// Sass/SCSSローダーの設定を追加
const sassLoader = {
  test: /\.(scss|sass)$/,
  use: [
    {
      loader: 'style-loader' // もしくは MiniCssExtractPlugin.loader を使用する場合はそちらを使用
    },
    {
      loader: 'css-loader',
      options: {
        sourceMap: true
      }
    },
    {
      loader: 'postcss-loader',
      options: {
        postcssOptions: {
          plugins: [
            require('postcss-import'),
            require('postcss-flexbugs-fixes'),
            require('postcss-preset-env')({
              autoprefixer: {
                flexbox: 'no-2009'
              },
              stage: 3
            })
          ]
        },
        sourceMap: true
      }
    },
    {
      loader: 'sass-loader',
      options: {
        sourceMap: true
      }
    }
  ],
  include: resolve(__dirname, '../../app/javascript/stylesheets')
}

environment.loaders.append('sass', sassLoader)

module.exports = environment
