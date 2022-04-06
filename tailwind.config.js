module.exports = {
  content: [
    './src/**/*.elm',
    './js/app.js',
    './html/index.html',
    './css/styles.css',
  ],
  media: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        slate: {
          0: '#FFFFFF'
        },
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
