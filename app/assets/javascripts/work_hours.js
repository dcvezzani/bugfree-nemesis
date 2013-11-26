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

        setTimeout(function(){
        $("#myModal .modal-body").find("input:visible, textarea:visible").first().focus();
        }, 500);

      });
      return false;
    });
  }


  // button: "Save changes"
  function init_work_hours_log_save_changes(selector){
    $(selector).find("button:contains('Save changes')").click(function(){
      reset_alerts();

      var form = $(this).closest("#myModal").find(".modal-body form");
      var href = $(form).attr("action");
      var method = "post";
      var csrf = $("meta[name='csrf-token']").attr("content");
      var data = "_method=" + method + "&authenticity_token=" + csrf + "&" + $(form).serialize() + "&response_type=msg-content";

      post_form_and_update_story_summaries(href, data, "Unable to update hours worked.");

      return false;
    });
  }

