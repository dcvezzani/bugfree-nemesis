  function init_work_timer(){
    $("#myonoffswitch").click(function(){
      $(".alert").fadeOut();
      var checkbox = $(this);

      // assumes the checkbox has already been updated
      current_state = $(checkbox).prop("checked");

      var form = $(checkbox).closest("form");
      var href = $(form).attr("action");
      var data = $(form).serialize();

      console.log("href: " + href);
      console.log("data: " + data);
      $.post(href, data, function(data){
        $(".alert-success").html(data["msg"]);
        $(".alert-success").fadeIn();

        setTimeout(function(){
          update_work_intervals();
        }, 150);

        // alert("success");
      }, "json")
      .fail(function(jqXHR, textStatus, errorThrown){
        $(checkbox).prop("checked", !current_state);
        data = JSON.parse(jqXHR.responseText);
        $(".alert-error").html(data["msg"]);
        $(".alert-error").fadeIn();
        // alert("error");
      });
    });
  }


  function update_work_intervals(){
    var href = $("#internal-references a:contains('show work intervals')").attr("href");
    $.get(href, function(data){
      $("#work-intervals").html(data);
    });
  }

  function init_hour_updater(){
    $(".update-hours input[type='number']").blur(function(){
      $(".alert").fadeOut();

      var form = $(this).closest("form");
      var href = $(form).attr("action");
      var data = $(form).serialize();

      $.post(href, data, function(){}, "json")
      .done(function(data, textStatus, jqXHR) {
        if(jqXHR.status == 304){
        } else {
          $(".alert-success").html(data["msg"]);
          $(".alert-success").fadeIn();
        }
      })
      .fail(function(jqXHR, textStatus, errorThrown){
        data = JSON.parse(jqXHR.responseText);

        $(".alert-error").html(data["msg"]);
        $(".alert-error").fadeIn();
      })

      return false; 
    });
  }

