window.onload = function () {
    var name = document.querySelector('#malone_tuning_name'),
        form = document.forms['new_malone_tuning'];
    form.onsubmit = function () {
        name.value = 'Malone - ' + name.value;
    };
};

