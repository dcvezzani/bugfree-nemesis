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

        _callbacks["modal"]["add_work_hours"]();
        
        setTimeout(function(){
        $("#myModal .modal-body").find("input:visible, textarea:visible").first().focus();
        }, 500);

      });
      return false;
    });
  }

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

  // a: Actions
  function init_story_work_hours_actions(selector){
    init_story_work_hours_show(selector);
    init_story_work_hours_edit(selector);
    init_story_work_hours_destroy(selector);
  }

  $('#myModal').on('hidden', function () {
    $(this).find(".modal-footer button:contains('Save changes')").show();
  })

  function modal_show(options){
    var mutable = (options["mutable"] == null) ? true : (options["mutable"] == true);
    console.log("mutable: " + mutable);

    if(mutable){
      $("#myModal .modal-footer button:contains('Save changes')").show();
    } else {
      $("#myModal .modal-footer button:contains('Save changes')").hide();
    }

    $("#myModal").modal("show");
  }

  // a: "Show"
  function init_story_work_hours_show(selector){
    $(selector).find("a:contains('Show')").click(function(){
      reset_alerts();

      var anchor = $(this);
      var href = $(anchor).attr("href");

      $.get(href, function(data){
        $("#myModal .modal-body").html(data);
        $("#myModalLabel").text("Show work hour segment");
        $("#myModal").modal("show");
        modal_show({mutable: false});

        setTimeout(function(){
        $("#myModal .modal-body").find("input:visible, textarea:visible").first().focus();
        }, 500);

      });
      return false;
    });
  }

  // a: "Edit"
  function init_story_work_hours_edit(selector){
    $(selector).find("a:contains('Edit')").click(function(){
      reset_alerts();

      var anchor = $(this);
      var href = $(anchor).attr("href");

      $.get(href, function(data){
        $("#myModal .modal-body").html(data);
        $("#myModalLabel").text("Edit work hour segment");
        // $("#myModal").modal("show");
        modal_show({mutable: true});

        setTimeout(function(){
        $("#myModal .modal-body").find("input:visible, textarea:visible").first().focus();
        }, 500);

      });
      return false;
    });
  }

  // a: "Destroy"
  function init_story_work_hours_destroy(selector){
    $(selector).find("a:contains('Destroy')").click(function(){
      reset_alerts();

      if(confirm("Are you sure?!")){
        var anchor = $(this);
        var href = $(anchor).attr("href");
        var method = $(anchor).attr("data-method");
        var csrf = $("meta[name='csrf-token']").attr("content");
        var data = "_method=" + method + "&authenticity_token=" + csrf;

        $.post(href, data, function(data){
          $(".alert-success").html(data["msg"]);
          $(".alert-success").fadeIn();
          $("#scratch-pad").html(data);

          // $(anchor).closest(".row").fadeOut();
          _callbacks["modal"]["save_work_hours"]();

        })
        .fail(function(jqXHR, textStatus, errorThrown){
          $(".alert-error").html("Unable to delete work hour segment.");
          $(".alert-error").fadeIn();
        });
      }
      return false;
    });
  }


  // button: "Get work hours for story"
  function init_story_work_hours(selector_src, selector_dest){
    $(selector_src).find(".get-hours").click(function(){
      reset_alerts();

      var anchor = $(this);

      if($(anchor).text().match(/Details/)){
        show_details(anchor, selector_dest);
        //   var row = $(selector_dest).find(".row");
        //   init_story_work_hours_actions(row);
        // });

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

        setTimeout(function(){
          _callbacks["a"]["show_details"]();
          _callbacks["a"]["add_work_hours"]();
        }, 150);
      });
  }

  function hide_details(anchor, selector_dest){
      var href = $(anchor).attr("href");

      $.get(href, function(data){
        $(anchor).text("Details");
        $(selector_dest).html("");
      });
  }
  
