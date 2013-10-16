  /* notes */ 

  // popup form
  function init_note_form(){
    init_note_log_save_changes("#myModal .modal-footer");
  }

  // inline links
  function init_note_logs(){
    init_note_log_add_note("#note-log");
    init_note_log_edit_note("#note-log");
    init_note_log_delete_note("#note-log-entries");
  }

  // input: "Update Note"
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

  // a: "Edit"
  function init_note_log_edit_note(selector){
    $(selector).find("a:contains('Edit')").click(function(){
      var anchor = $(this);
      var notes_well = $(anchor).closest("li").find(".notes.well");
      if($(notes_well).find("form").length > 0){
        return false;
      }

      var href = $(anchor).attr("href");

      $.get(href, function(data){
        $(notes_well).find(".description-paragraphs").hide();
        $(notes_well).append(data);

        setTimeout(function(){ init_note_form_content(notes_well); }, 150);
      });
      return false;
    });
  }

  // a: "Add note"
  function init_note_log_add_note(selector){
    $(selector).find("a:contains('Add note')").click(function(){
      var anchor = $(this);
      var href = $(anchor).attr("href");

      $.get(href, function(data){
        $("#myModal .modal-body").html(data);
        $("#myModalLabel").text("Add note");
        $("#myModal").modal("show");
      });
      return false;
    });
  }

  // a: "Destroy"
  function init_note_log_delete_note(selector){
    $(selector).find("a:contains('Destroy')").click(function(){
      if(confirm("Are` you sure?")){
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

  // button: "Save changes"
  function init_note_log_save_changes(selector){
    $(selector).find("button:contains('Save changes')").click(function(){
      var form = $(this).closest("#myModal").find(".modal-body form");
      var href = $(form).attr("action");
      var method = "post";
      var csrf = $("meta[name='csrf-token']").attr("content");
      var data = "_method=" + method + "&authenticity_token=" + csrf + "&" + $(form).serialize();
      
      $.post(href, data, function(data){
        $("#note-log-entries li:last").before(data);
        $("#myModal").modal("hide");

        setTimeout(function(){
          var new_item = $("#note-log-entries li:last").prev();

          init_note_log_delete_note(new_item);
          init_note_log_edit_note(new_item)
        }, 150);
        
        
      })
      .fail(function(jqXHR, textStatus, errorThrown){
        $(".modal-alert-error").html("Unable to save note.");
        $(".modal-alert-error").fadeIn();
      });

      return false;
    });
  }
  

  /* work timer */ 

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
