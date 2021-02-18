function running() {
  $.ajax({
    url : 'ajax.php',
    data:{"query":"running"},
    type: 'POST',
    success: function(data){
      $('#running').html(data);
    }
  });
}

function load() {
  $.ajax({
    url : 'ajax.php',
    data:{"query":"load"},
    type: 'POST',
    success: function(data){
      $('#load').html(data);
    }
  });
}

function size() {
  $.ajax({
    url : 'ajax.php',
    data:{"query":"size"},
    type: 'POST',
    success: function(data){
      $('#size').html(data);
    }
  });
}

function df() {
  $.ajax({
    url : 'ajax.php',
    data:{"query":"df"},
    type: 'POST',
    success: function(data){
      $('#df').html(data);
    }
  });
}

function uptime() {
  $.ajax({
    url : 'ajax.php',
    data:{"query":"uptime"},
    type: 'POST',
    success: function(data){
      $('#uptime').html(data);
    }
  });
}

$(document).ready(function() {

  uptime();
  setInterval(function(){ uptime(); }, 1000);

  running();
  setInterval(function(){ running(); }, 5000);

  load();
  setInterval(function(){ load(); }, 30000);

  size();
  df();
  setInterval(function(){ size(); df(); }, 1800000);

});


