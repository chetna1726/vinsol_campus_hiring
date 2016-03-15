$(document).ready(function() {
    var question = new Question("question_area");
    question.initialise();
});

function Question(containerId) {
    var object = this;

    //initialise the class object
    this.initialise = function() {
        this.container = $("#" + containerId);
        this.addEvents();
    };

    //add event handlers for all the events.
    this.addEvents = function() {
        this.container.on("click", ".answers", this.ensureSingleAnswerSelected);
        this.container.on('change', '#parent_category', this.populateSubCategories);
        this.container.on('click', ".add_fields", this.addFields);
        this.container.on('click', ".remove_fields", this.removeFields);
        this.setSelectedCategory();
        $('.remove_image').on('click', this.removeImage);
        $('#question_image').on('change', this.resetDeleteImageTag)
    };

    //remove image
    this.removeImage = function() {
        var button = $(this);
        button.parent().hide();
        $('#question_image').show();
        $('#question_image_delete').val(1);
    }

    this.resetDeleteImageTag = function() {
        $('#question_image_delete').val(0);
    };

    //set the selected parent category on page load.
    this.setSelectedCategory = function() {
        var category = $('#parent_category');
        var selectedCategory = category.data('selected');
        category.val(selectedCategory);
    };

    this.populateSubCategories = function() {
        var categorySelectList = $(this);
        var subcategories = categorySelectList.data('subcategories');
        var selectedCategory = categorySelectList.val();
        var subcategorySelectList = $('#question_category_id');
        subcategorySelectList.html("<option value=''>Choose Sub Category</option>");
        $.each(subcategories, function(index, subcategory) {
            if (subcategory.parent_id == selectedCategory) {
                $("<option/>", {
                    value: subcategory.id
                }).text(subcategory.name).appendTo(subcategorySelectList);
            }
        });
    };

    //on clicking correct answer checkbox, ensure only one checkbox is selected.
    this.ensureSingleAnswerSelected = function() {
        var current_answer = $(this)
        if (current_answer.is(":checked")) {
            current_answer.parents('tr').siblings('tr').find(".answers").attr("checked", false);
        }
    };

    // remove an answer or option field
    this.removeFields = function() {
        var link = $(this);
        $(link).prev("input[type=hidden]").val("1");
        $(link).closest("tr.fields").addClass('hidden-element').hide();
    };

    //add another answer or option field
    this.addFields = function() {
        var link = $(this)
        var new_id = new Date().getTime();
        var regexp = new RegExp("new_" + link.data('association'), "g");
        // #FIXME_AB: console.log has on issue if it is not defined in one browser like IE. Handle this like: http://digitalize.ca/2010/04/javascript-tip-save-me-from-console-log-errors/ 
        $(link).closest('tr').before(link.data('fields').replace(regexp, new_id));
    };

}