(function(window){
  window.RangeSlider = {
    init: function(id){
      const el = document.getElementById(id);
      const val = document.getElementById(id + "_val");
      if(!el || !val) return;
      el.addEventListener("input", ()=> val.textContent = el.value);
    }
  };
})(window);