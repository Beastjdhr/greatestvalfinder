$(document).ready( () => {
  var minWidth=$(window).width();
  var cross=false;
  if(minWidth>900) {
$('#mainTitle').css('padding-top','30rem');
  $('.mainTitle').css('padding-top','25rem');
  console.log(minWidth);
}
else {
  console.log('mobile');

  $('.mainTitle').css('padding-top','60vh');
  $('#mainTitle').css('padding-top','70vh');


  $('#bars').click( ()=> {
    if (cross===false) {
      $('#tabs').css('position','fixed');
      $('#tabs').css('display', 'block');
      $("#tabs").css('margin-top','7.5vh');
      $("#bars").removeClass('fa-bars');
      $('#bars').addClass('fa-times');
      cross=true;
    }
    else {
      $('#tabs').css('display','none');
      $('#bars').removeClass('fa-times');
      $('#bars').addClass('fa-bars');
      cross=false;
    }
  });
}
});
