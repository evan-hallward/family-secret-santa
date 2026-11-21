// Gentle background snowfall. Needs an element with id="snow" on the page.
(function () {
  const box = document.getElementById('snow');
  if (!box) return;
  for (let i = 0; i < 40; i++) {
    const s = document.createElement('span');
    const size = 3 + Math.random() * 5;
    s.style.cssText = `left:${Math.random() * 100}%;width:${size}px;height:${size}px;` +
      `animation-duration:${8 + Math.random() * 10}s;animation-delay:${-Math.random() * 18}s;` +
      `--drift:${(Math.random() - .5) * 80}px`;
    box.appendChild(s);
  }
})();
