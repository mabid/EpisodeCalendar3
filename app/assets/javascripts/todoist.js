function initTodoList() {
  if ($("#todo")) {
    window.todoistApiKey = "0fce5320b6386d4ad490f96328053f7b06fc9520";
    getTotodoistProjects();
  }
}

function getTotodoistProjects() {
  var script = document.createElement("script");
  script.type = "text/javascript";
  script.src = "http://todoist.com/API/getProjects?token=" + todoistApiKey + "&callback=getTotodoistProjectsCallback";
  document.getElementsByTagName("head")[0].appendChild(script);
}

function getTotodoistProjectsCallback(data) {
  var projectname = "EpisodeCalendarTodo";
  $(data).each(function(t) {
    if(this.name == projectname) {
      getUncompletedItems(this.id);
      getCompletedItems(this.id);
    }
  });
}

function getUncompletedItems(project_id) {
  var script = document.createElement("script");
  script.type = "text/javascript";
  script.src = "http://todoist.com/API/getUncompletedItems?token=" + todoistApiKey + "&project_id=" + project_id + "&callback=getUncompletedItemsCallback";
  document.getElementsByTagName("head")[0].appendChild(script);
}

function getUncompletedItemsCallback(data) {
  $("#ajax_loader").hide();
  $(data).each(function(t) {
    var html = $("<li>").text(this.content);
    $("#priority_" + this.priority + " ul").append(html).parent().find("h3").removeClass("hidden");
  });
}

function getCompletedItems(project_id) {
  var script = document.createElement("script");
  script.type = "text/javascript";
  script.src = "http://todoist.com/API/getCompletedItems?token=" + todoistApiKey + "&project_id=" + project_id + "&callback=getCompletedItemsCallback";
  document.getElementsByTagName("head")[0].appendChild(script);
}

function getCompletedItemsCallback(data) {
  if (data.length > 0)
    $("#completed_tasks h2").show();
  $(data).each(function(t) {
    var html = $("<li>").text(this.content);
    $("#completed_tasks ul").append(html).parent().find("h3").removeClass("hidden");
  });
}