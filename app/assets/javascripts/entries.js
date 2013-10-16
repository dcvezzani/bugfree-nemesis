  function init_note_logs(){
    init_note_log_add_note("#note-log a:contains('Add note')");
    init_note_log_edit_note("#note-log a:contains('Edit')");

    init_note_log_items("#note-log-entries a:contains('Destroy')");
  }

  // button: "Update Note"
  // button: "Cancel"
  function init_note_form_content(selector){
    $(selector).find("input[value='Update Note']").click(function(){
      var button = $(this);
      var form = $(button).closest("form");
      var href = $(form).attr("action");
      var method = "put";
      var csrf = $("meta[name='csrf-token']").attr("content");
      var data = "_method=" + method + "&authenticity_token=" + csrf + "&" + $(form).serialize();

      $.post(href, data, function(data){
        $(".alert-success").html(data["msg"]);
        $(".alert-success").fadeIn();

        $(button).closest(".notes.well").html(data["content"]);

      }, "json")
      .fail(function(jqXHR, textStatus, errorThrown){
        $(".alert-error").html("Unable to delete note.");
        $(".alert-error").fadeIn();
      });

      return false;
    });

    $(selector).find("button:contains('Cancel')").click(function(){
      var notes_well = $(".notes.well");
      $(this).closest("form").remove();
      $(notes_well).find(".description-paragraphs").show();

      return false;
    });
  }

  function init_note_log_edit_note(selector){
    $(selector).click(function(){
      var anchor = $(this);
      var href = $(anchor).attr("href");

      $.get(href, function(data){
        var notes_well = $(anchor).closest("li").find(".notes.well");
        $(notes_well).find(".description-paragraphs").hide();
        $(notes_well).append(data);

        setTimeout(function(){ init_note_form_content(notes_well); }, 150);
      });
      return false;
    });
  }

  function init_note_log_add_note(selector){
    $(selector).click(function(){
      var anchor = $(this);
      var href = $(anchor).attr("href");

      $.get(href, function(data){
        $("#myModal .modal-body").html(data);
        $("#myModalLabel").text("Add note");
        $("#myModal").modal("show");

        // setTimeout(function(){ init_note_form(); }, 150);
      });
      return false;
    });
  }

  function init_note_log_items(selector){
    $(selector).click(function(){
      if(confirm("Are you sure?")){
        var anchor = $(this);
        var href = $(anchor).attr("href");
        var method = $(anchor).attr("data-method");
        var csrf = $("meta[name='csrf-token']").attr("content");
        var data = "_method=" + method + "&authenticity_token=" + csrf;

        $.post(href, data, function(data){
          $(".alert-success").html(data["msg"]);
          $(".alert-success").fadeIn();
          $(anchor).closest("li").fadeOut();

        }, "json")
        .fail(function(jqXHR, textStatus, errorThrown){
          $(".alert-error").html("Unable to delete note.");
          $(".alert-error").fadeIn();
        });
      }
      return false;
    });
  }

  function init_note_form(){
    $("#myModal .modal-footer button:contains('Save changes')").click(function(){
      var form = $(this).closest("#myModal").find(".modal-body form");
      var href = $(form).attr("action");
      // var method = $(anchor).attr("data-method");
      var method = "post";
      var csrf = $("meta[name='csrf-token']").attr("content");
      var data = "_method=" + method + "&authenticity_token=" + csrf + "&" + $(form).serialize();
      
      $.post(href, data, function(data){
        $("#note-log-entries li:last").before(data);
        $("#myModal").modal("hide");

        setTimeout(function(){
          var new_item = $("#note-log-entries li:last").prev();
          var delete_anchor = $(new_item).find("a:contains('Destroy')");
          init_note_log_items(delete_anchor);

          var edit_anchor = $(new_item).find("a:contains('Edit')");
          init_note_log_edit_note(edit_anchor)
        }, 150);
        
        
      })
      .fail(function(jqXHR, textStatus, errorThrown){
        $(".modal-alert-error").html("Unable to save note.");
        $(".modal-alert-error").fadeIn();
      });

      return false;
    });
  }

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
      $(".work-intervals").html(data);
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

