const cart = JSON.parse(localStorage.getItem('soleTheoryCart') || '[]');
let deliveryFee = 99;
let appliedPromo = null;
let discountAmount = 0;

function renderOrderSummary() {
  const summaryItems = document.getElementById('summaryItems');
  const summarySubtotal = document.getElementById('summarySubtotal');
  const summaryDelivery = document.getElementById('summaryDelivery');
  const summaryDiscount = document.getElementById('summaryDiscount');
  const discountRow = document.getElementById('discountRow');
  const discountLabel = document.getElementById('discountLabel');
  const summaryTotal = document.getElementById('summaryTotal');

  if (cart.length === 0) {
    summaryItems.innerHTML = '<p class="empty-summary">Your cart is empty</p>';
    summarySubtotal.textContent = 'R 0.00';
    summaryTotal.textContent = `R ${deliveryFee.toFixed(2)}`;
    return;
  }

  let subtotal = 0;
  summaryItems.innerHTML = '';

  cart.forEach(item => {
    subtotal += item.price * item.quantity;

    const itemEl = document.createElement('div');
    itemEl.className = 'summary-item';
    itemEl.innerHTML = `
      <div class="summary-item-image"></div>
      <div class="summary-item-info">
        <div class="summary-item-name">${item.name}</div>
        <div class="summary-item-details">Qty: ${item.quantity}</div>
      </div>
      <div class="summary-item-price">R ${(item.price * item.quantity).toFixed(2)}</div>
    `;
    summaryItems.appendChild(itemEl);
  });

  if (appliedPromo) {
    if (appliedPromo.discount_type === 'percentage') {
      discountAmount = subtotal * (appliedPromo.discount_value / 100);
      discountLabel.textContent = `(${appliedPromo.discount_value}%)`;
    } else {
      discountAmount = appliedPromo.discount_value;
      discountLabel.textContent = '';
    }
    discountRow.style.display = 'flex';
    summaryDiscount.textContent = `-R ${discountAmount.toFixed(2)}`;
  } else {
    discountRow.style.display = 'none';
    discountAmount = 0;
  }

  const total = subtotal + deliveryFee - discountAmount;

  summarySubtotal.textContent = `R ${subtotal.toFixed(2)}`;
  summaryDelivery.textContent = `R ${deliveryFee.toFixed(2)}`;
  summaryTotal.textContent = `R ${total.toFixed(2)}`;
}

const deliveryOptions = document.querySelectorAll('input[name="delivery"]');
deliveryOptions.forEach(option => {
  option.addEventListener('change', (e) => {
    switch(e.target.value) {
      case 'standard':
        deliveryFee = 99;
        break;
      case 'express':
        deliveryFee = 199;
        break;
      case 'overnight':
        deliveryFee = 299;
        break;
    }
    renderOrderSummary();
  });
});

const promoInput = document.getElementById('promoCodeInput');
const applyPromoBtn = document.getElementById('applyPromoBtn');
const promoMessage = document.getElementById('promoMessage');

applyPromoBtn.addEventListener('click', async () => {
  const code = promoInput.value.trim().toUpperCase();

  if (!code) {
    showPromoMessage('Please enter a promo code', 'error');
    return;
  }

  applyPromoBtn.disabled = true;
  applyPromoBtn.textContent = 'CHECKING...';

  if (code === 'BLACKFRIDAY') {
    appliedPromo = {
      code: 'BLACKFRIDAY',
      discount_type: 'percentage',
      discount_value: 40
    };
    showPromoMessage('40% discount applied!', 'success');
    renderOrderSummary();
    promoInput.disabled = true;
    applyPromoBtn.textContent = 'APPLIED';
  } else {
    showPromoMessage('Invalid promo code', 'error');
    applyPromoBtn.disabled = false;
    applyPromoBtn.textContent = 'APPLY';
  }
});

function showPromoMessage(message, type) {
  promoMessage.textContent = message;
  promoMessage.className = `promo-message ${type}`;

  if (type === 'error') {
    setTimeout(() => {
      promoMessage.textContent = '';
      promoMessage.className = 'promo-message';
    }, 3000);
  }
}

document.getElementById('continueToPayment').addEventListener('click', (e) => {
  e.preventDefault();

  const form = document.getElementById('checkoutForm');
  const firstName = document.getElementById('firstName').value;
  const lastName = document.getElementById('lastName').value;
  const email = document.getElementById('email').value;
  const phone = document.getElementById('phone').value;
  const address = document.getElementById('address').value;
  const city = document.getElementById('city').value;
  const province = document.getElementById('province').value;
  const postalCode = document.getElementById('postalCode').value;

  if (!email || !phone || !firstName || !lastName || !address || !city || !province || !postalCode) {
    alert('Please fill in all required fields');
    return;
  }

  const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  const total = subtotal + deliveryFee - discountAmount;

  const orderData = {
    customer: { firstName, lastName, email, phone },
    address: { address, city, province, postalCode },
    delivery: document.querySelector('input[name="delivery"]:checked').value,
    cart: cart,
    subtotal: subtotal,
    deliveryFee: deliveryFee,
    promoCode: appliedPromo ? appliedPromo.code : null,
    discountAmount: discountAmount,
    total: total
  };

  localStorage.setItem('soleTheoryOrder', JSON.stringify(orderData));

  alert('Order details saved! In a production environment, this would now redirect to a secure payment gateway.');
  console.log('Order Data:', orderData);
});

renderOrderSummary();
