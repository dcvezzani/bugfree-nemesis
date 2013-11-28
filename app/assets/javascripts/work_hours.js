  /* work_hours */ 

  // popup form
  function init_work_hours_form(){
    init_work_hours_log_save_changes("#myModal .modal-footer");
  }

  // a: "Add work_hours"
  function init_work_hours_log_add_work_hours(selector){
    $(selector).click(function(){
      reset_alerts();

      var anchor = $(this);
      var href = $(anchor).attr("href");

      $.get(href, function(data){
        $("#myModal .modal-body").html(data);
        $("#myModalLabel").text("Add hours worked");
        $("#myModal").modal("show");

        var story_list_today = $("#story-list-today");

        setTimeout(function(){ init_work_hours_form(story_list_today); }, 150);
        
        setTimeout(function(){
        $("#myModal .modal-body").find("input:visible, textarea:visible").first().focus();
        }, 500);

      });
      return false;
    });
  }


  // // input: "Update Note"
  // // button: "Cancel"
  // function init_note_form_content(selector){
  //   $(selector).find("input[value='Save Changes']").click(function(){
  //     reset_alerts();

  //     var button = $(this);
  //     var form = $(button).closest("form");
  //     var href = $(form).attr("action");
  //     var method = "put";
  //     var csrf = $("meta[name='csrf-token']").attr("content");
  //     var data = "_method=" + method + "&authenticity_token=" + csrf + "&" + $(form).serialize();

  //     $.post(href, data, function(data){
  //       $("#scratch-pad").html(data);

  //       setTimeout(function(){
  //         var msg = $("#scratch-pad .msg").html();
  //         var content = $("#scratch-pad .content").html();

  //         $(".alert-success").html(msg);
  //         $(".alert-success").fadeIn();
  //         $(button).closest(".notes.well").html(content);
  //       }, 150);
  //     })
  //     .fail(function(jqXHR, textStatus, errorThrown){
  //       $(".alert-error").html("Unable to delete note.");
  //       $(".alert-error").fadeIn();
  //     });

  //     return false;
  //   });

  //   $(selector).find("button:contains('Cancel')").click(function(){
  //     var notes_well = $(".notes.well");
  //     $(this).closest("form").remove();
  //     $(notes_well).find(".description-paragraphs").show();

  //     return false;
  //   });
  // }

  // button: "Save changes"
  function init_work_hours_log_save_changes(selector){
    $(selector).find("button:contains('Save changes')").unbind("click");

    $(selector).find("button:contains('Save changes')").click(function(){
      reset_alerts();

      var form = $(this).closest("#myModal").find(".modal-body form");
      var href = $(form).attr("action");
      var method = "post";
      var csrf = $("meta[name='csrf-token']").attr("content");
      var data = "_method=" + method + "&authenticity_token=" + csrf + "&" + $(form).serialize() + "&response_type=msg-content";

      post_form_and_update_story_summaries(href, data, "Unable to update hours worked.", function(){
    init_work_hours_log_add_work_hours("a:contains('Add hours worked')");
      });
      $("#myModal").modal("hide");
    });
  }


  // button: "Get work hours for story"
  function init_story_work_hours(selector_src, selector_dest){
    $(selector_src).find(".get-hours").click(function(){
      reset_alerts();

      var anchor = $(this);

      if($(anchor).text().match(/Details/)){
        show_details(anchor, selector_dest);
      } else {
        hide_details(anchor, selector_dest);
      }

      return false;
    });
  }

  function show_details(anchor, selector_dest){
      var href = $(anchor).attr("href");

      $.get(href, function(data){
        $(anchor).text("Hide details");
        $(selector_dest).html(data);
      });
  }

  function hide_details(anchor, selector_dest){
      var href = $(anchor).attr("href");

      $.get(href, function(data){
        $(anchor).text("Details");
        $(selector_dest).html("");
      });
  }
  
