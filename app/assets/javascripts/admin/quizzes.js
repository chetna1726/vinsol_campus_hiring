$(document).ready(function() {
    var quiz = new Quiz('questions_container', 'quizzes-main-container')
    quiz.initialise();
});

function Quiz(questionContainerId, quizzesContainerId) {
    var that = this;

    //initialise the class object
    this.initialise = function() {
        this.questionContainer = $('#' + questionContainerId);
        this.quizzesMainContainer = $('#' + quizzesContainerId);
        this.categorySelectList = $('#parent');
        this.difficultySelectList = $('#difficulty_level');
        this.subcategorySelectList = $('#category');
        this.questionTypeSelectList = $('#type');
        this.questionsTable = $('#questions-table');
        this.resultsContainer = $('#results-container');
        this.sortButton = $('#sort_questions')
        this.selectExistingQuestions();
        this.addEvents();
    };

    // select the existing quiz questions
    this.selectExistingQuestions = function() {
        var questions = $('#questions-table');
        if (questions.length) {
            $.each(questions.data('questions'), function(index, value) {
                $('.chosen_questions[value="' + value + '"]').prop('checked', true);
            });
        }
    };


    // add event handlers
    this.addEvents = function() {
        this.questionContainer.on('change', '.chosen_questions', this.validateMaxCountOfQuestionsAndSendAjaxRequest);
        this.categorySelectList.on('change', this.populateSubCategories);
        this.sortButton.on('click', this.filterQuestions);
        this.questionContainer.on('click', '.pagination-container a', this.paginateAndSelectExistingQuestions);
        this.quizzesMainContainer.on('click', '.pagination-container a', this.paginateQuizzes);
        $('.quiz-tabs').on('click', 'li a', this.switchTabs)
        $('.datetimepicker').datetimepicker();
        $('#sort_order, #sort_by').on('change', this.sortResults);
        $('#clear_filters').on('click', this.clearFilterAndfilterQuestions);
        $('#clear_all').on('click', this.clearFilters);
        $('#add_questions').on('click', this.addQuestions);
        this.questionContainer.on('click', '.remove_questions', this.removeQuestion)
    };

    this.showError = function(errorText) {
        this.showAlert(errorText, 'alert-danger');
    };

    this.hideAlert = function() {
        $('#alert').hide();
    }

    this.showAlert = function(text, alertClass) {
        $('#alert').html(text).attr('class', 'alert ' + alertClass).show();
    };

    this.showSuccess = function(successText) {
        this.showAlert(successText, 'alert-success');
    }

    this.removeQuestion = function() {
        that.hideAlert();
        var currentQuestion = $(this);
        currentQuestion.css('cursor', 'wait');
        $('body').css('cursor', 'wait');
        $.ajax({
            url: that.questionContainer.data('remove_question'),
            data: {
                format: 'js',
                question_id: currentQuestion.val()
            },
            dataType: 'html',
            success: function(data) {
                $('#questions').html(data);
            }
        });
        currentQuestion.css('cursor', 'pointer');
        $('body').css('cursor', 'auto');
    }

    this.addQuestions = function() {
        that.hideAlert();
        var maxQuestions = $('#maximum_questions').text();
        if (maxQuestions > 0) {
            var requestedNumberOfQuestions = Number($('#num_ques').val())
            if (requestedNumberOfQuestions <= 0) {
                that.showError('Number of questions should be greater than zero');
            } else {
                if (maxQuestions >= requestedNumberOfQuestions) {
                    var filters = that.getFilters();
                    $.ajax({
                        url: $(this).data('href'),
                        data: {
                            filterHash: that.generateFilterHash(filters),
                            format: 'js',
                            num_questions: requestedNumberOfQuestions
                        },
                        dataType: 'html',
                        success: function(data) {
                            $('#questions').html(data);
                        }
                    }).complete(function() {
                        var maxQuestions = Number($('#maximum_questions').text());
                        if (!maxQuestions)
                            that.showSuccess('Quiz is ready');
                    });
                } else
                    that.showError("Max Remaining Questions = " + maxQuestions);
            }
        } else
            that.showError('No more questions can be selected. Your quiz is ready');
    };

    this.switchTabs = function(e) {
        e.preventDefault();
        var currentTab = $(this);
        var parent = currentTab.closest('li');
        $.ajax({
            url: currentTab.closest('ul').data('href'),
            data: {
                format: 'js',
                attemptable: currentTab.data('attemptable'),
                expired: currentTab.data('expired')
            },
            dataType: 'html',
            success: function(data) {
                $('#quizzes-container').html(data);
                parent.addClass('active').siblings('li').removeClass('active');
            }
        });
    };

    this.paginateQuizzes = function(e) {
        e.preventDefault();
        $.ajax({
            url: $(this).attr('href'),
            data: {
                format: 'js',
                attemptable: $('li.active a').data('attemptable')
            },
            dataType: 'html',
            success: function(data) {
                $('#quizzes-container').html(data);
            },
            error: function(xhr, textStatus, errorThrown) {
                $('body').html("<h1>" + textStatus + ": " + xhr.status + ", " + errorThrown + "</h1>");
            }
        });
    };

    //filter results on sorting by name or score
    this.sortResults = function() {
        var sort_by = $('#sort_by').val();
        var order = $('#sort_order').val();
        if (sort_by && order) {
            $.ajax({
                url: that.resultsContainer.data('href'),
                data: {
                    format: 'js',
                    sort_by: sort_by,
                    order: order
                },
                dataType: 'html',
                success: function(data) {
                    $('#results').html(data);
                }
            });
        }
    };

    // filter on pagination
    this.paginateAndSelectExistingQuestions = function(e) {
        e.preventDefault();
        $.ajax({
            url: $(this).attr('href'),
            data: {
                'format': 'js',
                filterHash: that.generateFilterHash(that.getFilters())
            },
            dataType: 'html',
            success: function(data) {
                $('#table').html(data);
            },
            error: function(xhr, textStatus, errorThrown) {
                $('body').html("<h1>" + textStatus + ": " + xhr.status + ", " + errorThrown + "</h1>");
            }
        }).complete(function() {
            that.questionsTable = $('#questions-table');
            that.selectExistingQuestions();
        });
    };


    this.validateMaxCountOfQuestionsAndSendAjaxRequest = function() {
        that.hideAlert();
        var currentQuestion = $(this);
        var question_id = currentQuestion.val();
        currentQuestion.css('cursor', 'wait');
        $('body').css('cursor', 'wait');
        if (currentQuestion.prop('checked')) {
            if (that.validateMaxCountOfQuestions()) {
                that.sendAjaxRequest(true, question_id, currentQuestion)
            } else {
                that.showError('Cannot select more questions');
                currentQuestion.prop('checked', false);
                currentQuestion.css('cursor', 'pointer');
                $('body').css('cursor', 'auto');
            }
        } else {
            that.sendAjaxRequest(false, question_id, currentQuestion)
        }
    };

    //send ajax request to add or remove questions
    this.sendAjaxRequest = function(add, question_id, checkbox) {
        var question_count_change_by = (add ? -1 : 1);
        $.ajax({
            async: false,
            url: this.questionContainer.data('update_questions'),
            data: {
                'question_id': question_id,
                'add': add
            },
            success: function(data) {
                if (data == 'error') {
                    that.showError('error occurred');
                    checkbox.prop('checked', !add);
                    $(window).scrollTop(0);
                } else {
                    that.hideAlert();
                    var change = that.questionContainer.data('num_questions') + question_count_change_by
                    that.questionContainer.data('num_questions', change);
                    var current_count = Number($('#questions_count').text());
                    $('#questions_count').text(current_count - question_count_change_by);
                    $('#marks').text(data);
                    if (!change) {
                        that.showSuccess('Quiz is ready');
                    }
                }
            },
            error: function(xhr, textStatus, errorThrown) {
                $('body').html("<h1>" + textStatus + ": " + xhr.status + ", " + errorThrown + "</h1>");
            }
        }).complete(function() {
            $('body').css("cursor", "auto");
            checkbox.css('cursor', 'pointer');
        })

    };

    // validate maximum questions selected
    this.validateMaxCountOfQuestions = function() {
        return (that.questionContainer.data('num_questions') > 0);
    };

    // populate sub category select list on selecting a category
    this.populateSubCategories = function() {
        var categorySelectList = $(this);
        var subcategories = categorySelectList.data('subcategories');
        var selectedCategory = categorySelectList.val();
        that.subcategorySelectList.html("<option value=''>Sub Category</option>");
        $.each(subcategories, function(index, subcategory) {
            if (subcategory.parent_id == selectedCategory) {
                $("<option/>", {
                    value: subcategory.id
                }).text(subcategory.name).appendTo(that.subcategorySelectList);
            }
        });
    };

    // filter the questions on the basis of the filters
    this.filterQuestions = function() {
        var filters = that.getFilters();
        var filterHash = that.generateFilterHash(filters);
        that.hideAlert();
        if (!jQuery.isEmptyObject(filterHash)) {
            $.ajax({
                url: that.questionContainer.data('sort_questions'),
                data: {
                    filterHash: filterHash,
                    format: 'js'
                },
                dataType: 'html',
                success: function(data) {
                    $('#table').html(data);
                    that.selectExistingQuestions();
                }
            });
        } else {
            that.showError('No filters selected');
        }
    };

    this.clearFilterAndfilterQuestions = function() {
        that.clearFilters();
        that.filterQuestions();
    }

    this.clearFilters = function() {
        $('.filters').val('');
        that.subcategorySelectList.html("<option value=''>Sub Category</option>");
    }

    // generate filter string
    this.generateFilterHash = function(filters) {
        var filterHash = {}
        for (var key in filters) {
            if (filters[key]) {
                if (filters[key] instanceof Object) {
                    for (var sub_key in filters[key]) {
                        if (filters[key][sub_key])
                            filterHash[key] = filters[key];
                    }
                } else
                    filterHash[key] = filters[key];
            }
        }
        return filterHash;
    };

    // get the selected filters
    this.getFilters = function() {
        return {
            category_id: this.subcategorySelectList.val(),
            difficulty_level_id: this.difficultySelectList.val(),
            type: this.questionTypeSelectList.val(),
            categories: {
                parent_id: this.categorySelectList.val()
            }
        };
    };
}