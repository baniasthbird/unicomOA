var count = document.images.length;
var i_Width= window.screen.width-100;
 for (var i = 0; i < count; i++)
  {
  	  var image = document.images[i];
      var imgWidth= image.width
      var imgHeight= image.height;
      var iRatio=imgHeight/imgWidth;
      var targetHeight=i_Width*iRatio;
      image.style.width=i_Width;  
      image.style.height=targetHeight;
  }