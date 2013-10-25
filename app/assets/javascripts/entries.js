  /* notes */ 

  function reset_alerts(){
    $(".alert-success").fadeOut();
    $(".alert-error").fadeOut();
  }

  // popup form
  function init_note_form(){
    init_note_log_save_changes("#myModal .modal-footer");
  }

  // inline links
  function init_note_logs(){
    init_note_log_add_note("#note-log");
    init_note_log_edit_note("#note-log");
    init_note_log_delete_note("#note-log-entries, #note-log-items");
  }

  function init_mark_as_done(selector){
    $(selector).click(function(){
      reset_alerts();

      var anchor = $(this);
      var href = $(anchor).attr("href");
      var method = "put";
      var csrf = $("meta[name='csrf-token']").attr("content");
      var entry_id = $("#entry_id").val();
      var data = "_method=" + method + "&authenticity_token=" + csrf + "&entry_id=" + entry_id + "&response_type=msg-content"

      $.post(href, data, function(data){
        $("#scratch-pad").html(data);

        setTimeout(function(){
          var yesterdays_stories = $("#scratch-pad .content .story-list-yesterday").html();
          var todays_stories = $("#scratch-pad .content .story-list-today").html();
          var show_stopper_stories = $("#scratch-pad .content .story-list-show-stopper").html();

          $("#story-list-yesterday").html(yesterdays_stories).effect("highlight", {}, 1500);
          $("#story-list-today").html(todays_stories).effect("highlight", {}, 1500);

          var msg = $("#scratch-pad .msg").html();
          $(".alert-success").html(msg);
          $(".alert-success").fadeIn();
        }, 150);
      })
      .fail(function(jqXHR, textStatus, errorThrown){
        $(".alert-error").html("Unable to mark story as complete.");
        $(".alert-error").fadeIn();
      });

      
      return false;
    });
  }

  function gather_yesterdays_goals(){
    return gather_goals(".yesterdays-goals");
  }

  function gather_todays_goals(){
    return gather_goals(".todays-goals");
  }

  function gather_goals(selector){
    var title = $(selector).find("p:first b:first").text();

    var todays_log = $(selector).find("ul:first li").map(function(i, item){
      return $(item).text();
    });

    var related_stories_legend = $(selector).find(".story-list").prev().text();
    var related_stories = $(selector).find(".story-list li").find("a:first").map(function(i, _anchor){
      return $(_anchor).text();
    });

    var body_lines = [title, "====================================", "", "- " + todays_log.toArray().join("\n- "), "", related_stories_legend, "", "- " + related_stories.toArray().join("\n- ")];

    // var body = $(anchor).closest(".todays-goals").text();
    var body = body_lines.join("\n");
    return body;
  }

  function gather_notes(){
    var log_entries = $("ul#note-log-entries .well.notes .description-paragraphs").map(function(i,item){
      return $(item).text().replace(/^\s+|\s+$/, "");
    }).toArray();

    var story_log_entries = $("ul#related-story-note-log-entries .well.notes").map(function(i,item){
      var story_name = $(item).find("h4").text().replace(/^\s+|\s+$/, "");
      var note_content = $(item).find(".description-paragraphs").text().replace(/^\s+|\s+$/, "");
      return story_name + ": " + note_content;
    }).toArray();

    var out = []

    if(log_entries.length > 0){ out[out.length] = "Notes" + "\n" + "====================================" + "\n\n" + "- " + log_entries.join("- \n");}
    if(story_log_entries.length > 0){ out[out.length] = "Story notes" + "\n" + "====================================" + "\n\n" + "- " + story_log_entries.join("- \n");}

    return out.join("\n\n");
  }

  function init_email_goals_to_manager(selector){
    $(selector).click(function(){
      var anchor = $(this);
      var href = $(anchor).attr("href");

      window.location.href = href + escape("\n\n") + escape(gather_yesterdays_goals()) + escape("\n\n\n") + escape(gather_todays_goals()) + escape("\n\n\n") + escape(gather_notes()) + escape("\n\n");

      return false;
    });
  }

  // input: "Update Note"
  // button: "Cancel"
  function init_note_form_content(selector){
    $(selector).find("input[value='Update Note']").click(function(){
      reset_alerts();

      var button = $(this);
      var form = $(button).closest("form");
      var href = $(form).attr("action");
      var method = "put";
      var csrf = $("meta[name='csrf-token']").attr("content");
      var data = "_method=" + method + "&authenticity_token=" + csrf + "&" + $(form).serialize();

      $.post(href, data, function(data){
        $("#scratch-pad").html(data);

        setTimeout(function(){
          var msg = $("#scratch-pad .msg").html();
          var content = $("#scratch-pad .content").html();

          $(".alert-success").html(msg);
          $(".alert-success").fadeIn();
          $(button).closest(".notes.well").html(content);
        }, 150);
      })
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
      reset_alerts();

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
      reset_alerts();

      var anchor = $(this);
      var href = $(anchor).attr("href");

      $.get(href, function(data){
        $("#myModal .modal-body").html(data);
        $("#myModalLabel").text("Add note");
        $("#myModal").modal("show");

        setTimeout(function(){
        $("#myModal .modal-body").find("input:visible, textarea:visible").first().focus();
        }, 500);

      });
      return false;
    });
  }

  // a: "Destroy"
  function init_note_log_delete_note(selector){
    $(selector).find("a:contains('Destroy')").click(function(){
      reset_alerts();

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
      reset_alerts();

      var form = $(this).closest("#myModal").find(".modal-body form");
      var href = $(form).attr("action");
      var method = "post";
      var csrf = $("meta[name='csrf-token']").attr("content");
      var data = "_method=" + method + "&authenticity_token=" + csrf + "&" + $(form).serialize();
      
      $.post(href, data, function(data){
        $("#note-log-entries, #note-log-items").find("li:last").before(data);
        $("#myModal").modal("hide");

        setTimeout(function(){
          var new_item = $("#note-log-entries, #note-log-items").find("li:last").prev();

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
