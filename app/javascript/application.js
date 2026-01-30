import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

let timerInterval;

document.addEventListener('turbo:load', () => {
  const btn = document.getElementById('attendance-toggle-btn');
  const breakBtn = document.getElementById('break-toggle-btn');
  const display = document.getElementById('working-timer');
  
  const userIdMeta = document.querySelector('meta[name="current-user-id"]');
  const defaultTravelCostMeta = document.querySelector('meta[name="default-travel-cost"]');
  
  const userId = userIdMeta ? userIdMeta.content : null;
  const defaultTravelCost = defaultTravelCostMeta ? defaultTravelCostMeta.content : "0";

  if (!btn || !display || !userId) return;

  const startKey = `workStartTime_user_${userId}`;
  const breakStartKey = `breakStartTime_user_${userId}`;
  const totalBreakKey = `totalBreakMs_user_${userId}`;

  const savedStart = localStorage.getItem(startKey);
  const savedBreakStart = localStorage.getItem(breakStartKey);

  if (savedStart) {
    startCounter(new Date(savedStart), display);
    updateUI(btn, breakBtn, savedBreakStart ? 'on_break' : 'working');
  }

  btn.addEventListener('click', () => {
    const isStopped = btn.getAttribute('data-status') === 'stopped';
    const url = isStopped ? '/clock_in' : '/clock_out';
    const token = document.querySelector('meta[name="csrf-token"]').content;

    const bodyData = {};
    if (!isStopped) {
      const totalBreakMs = parseInt(localStorage.getItem(totalBreakKey) || "0");
      bodyData.break_minutes = Math.floor(totalBreakMs / 60000);
      bodyData.extra_travel_cost = parseInt(defaultTravelCost) || 0;
    }

    fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'X-CSRF-Token': token },
      body: JSON.stringify(bodyData)
    })
    .then(response => response.json())
    .then(data => {
      if (data.status === 'success') {
        if (isStopped) {
          // --- 出勤処理 ---
          const now = new Date();
          localStorage.setItem(startKey, now.toISOString());
          localStorage.setItem(totalBreakKey, "0");
          startCounter(now, display);
          updateUI(btn, breakBtn, 'working');
        } else {
          // --- 退勤処理（キャンセル不可に修正） ---
          // ローカルの記録を即座に削除
          [startKey, breakStartKey, totalBreakKey].forEach(k => localStorage.removeItem(k));
          
          if (timerInterval) clearInterval(timerInterval);
          
          // UIを「停止」状態に戻す
          updateUI(btn, breakBtn, 'stopped');
          display.textContent = '00:00:00';
          
          // 最後に通知だけ表示
          alert('退勤を記録しました！本日もお疲れ様でした！');
        }
      }
    });
  });

  breakBtn?.addEventListener('click', () => {
    const onBreak = !!localStorage.getItem(breakStartKey);
    const now = new Date();

    if (!onBreak) {
      localStorage.setItem(breakStartKey, now.toISOString());
      updateUI(btn, breakBtn, 'on_break');
    } else {
      const bStart = new Date(localStorage.getItem(breakStartKey));
      const currentBreakMs = parseInt(localStorage.getItem(totalBreakKey) || "0");
      localStorage.setItem(totalBreakKey, currentBreakMs + (now - bStart));
      localStorage.removeItem(breakStartKey);
      updateUI(btn, breakBtn, 'working');
    }
  });
});

function startCounter(startTime, display) {
  if (timerInterval) clearInterval(timerInterval);
  timerInterval = setInterval(() => {
    const now = new Date();
    const diff = now - startTime;
    const h = Math.floor(diff / 3600000).toString().padStart(2, '0');
    const m = Math.floor((diff % 3600000) / 60000).toString().padStart(2, '0');
    const s = Math.floor((diff % 60000) / 1000).toString().padStart(2, '0');
    display.textContent = `${h}:${m}:${s}`;
  }, 1000);
}

function updateUI(btn, breakBtn, status) {
  if (status === 'working') {
    btn.setAttribute('data-status', 'working');
    btn.innerHTML = '<i class="bi bi-stop-fill"></i> 退勤する';
    btn.className = 'btn btn-lg btn-danger py-3 shadow w-100';
    if (breakBtn) {
      breakBtn.classList.remove('d-none');
      breakBtn.innerHTML = '<i class="bi bi-pause-fill"></i> 休憩入';
      breakBtn.className = 'btn btn-warning mt-2 w-100';
    }
  } else if (status === 'on_break') {
    btn.className = 'btn btn-lg btn-secondary py-3 shadow w-100';
    if (breakBtn) {
      breakBtn.innerHTML = '<i class="bi bi-play-fill"></i> 休憩戻';
      breakBtn.className = 'btn btn-success mt-2 w-100';
    }
  } else {
    btn.setAttribute('data-status', 'stopped');
    btn.innerHTML = '<i class="bi bi-play-fill"></i> 出勤する';
    btn.className = 'btn btn-lg btn-success py-3 shadow w-100';
    breakBtn?.classList.add('d-none');
  }
}