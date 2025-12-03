// Global state
let currentView = 'category';
let currentZone = null;
let selectedTattoo = null;
let targetPlayerId = null;

// Zone Icons/Emojis
const zoneIcons = {
    'ZONE_TORSO': '🎨',
    'ZONE_HEAD': '👤',
    'ZONE_LEFT_ARM': '💪',
    'ZONE_RIGHT_ARM': '🦾',
    'ZONE_LEFT_LEG': '🦵',
    'ZONE_RIGHT_LEG': '🦿'
};

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    setupEventListeners();
});

// Setup event listeners
function setupEventListeners() {
    document.getElementById('close-btn').addEventListener('click', closeUI);
    document.getElementById('back-btn').addEventListener('click', showCategoryView);
    document.getElementById('cancel-btn').addEventListener('click', showTattooView);
    document.getElementById('confirm-btn').addEventListener('click', confirmTattoo);
    
    // ESC key to close
    document.addEventListener('keyup', (e) => {
        if (e.key === 'Escape') {
            closeUI();
        }
    });
}

// NUI Message Handler
window.addEventListener('message', (event) => {
    const data = event.data;
    
    switch(data.action) {
        case 'openUI':
            openUI(data.targetId, data.categories);
            break;
        case 'showTattoos':
            showTattoos(data.zone, data.tattoos);
            break;
        case 'closeUI':
            closeUI();
            break;
    }
});

// Open UI
function openUI(targetId, categories) {
    targetPlayerId = targetId;
    const ui = document.getElementById('tattoo-ui');
    ui.classList.remove('hidden');
    
    renderCategories(categories);
    showCategoryView();
}

// Close UI
function closeUI() {
    const ui = document.getElementById('tattoo-ui');
    ui.classList.add('hidden');
    
    fetch(`https://${GetParentResourceName()}/closeUI`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

// Render categories
function renderCategories(categories) {
    const grid = document.getElementById('category-grid');
    grid.innerHTML = '';
    
    categories.forEach(category => {
        const card = document.createElement('div');
        card.className = 'category-card';
        card.onclick = () => selectCategory(category.zone);
        
        card.innerHTML = `
            <div class="category-icon">${zoneIcons[category.zone] || '🎨'}</div>
            <div class="category-name">${category.name}</div>
            <div class="category-count">${category.count} Tattoos verfügbar</div>
        `;
        
        grid.appendChild(card);
    });
}

// Select category
function selectCategory(zone) {
    currentZone = zone;
    
    fetch(`https://${GetParentResourceName()}/selectCategory`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ zone: zone })
    });
}

// Show tattoos
function showTattoos(zone, tattoos) {
    currentZone = zone;
    
    const grid = document.getElementById('tattoo-grid');
    const title = document.getElementById('zone-title');
    const subtitle = document.getElementById('zone-subtitle');
    
    // Get zone name from first tattoo or use zone code
    const zoneName = tattoos[0]?.zoneName || zone;
    title.textContent = zoneName;
    subtitle.textContent = `${tattoos.length} Tattoos verfügbar`;
    
    grid.innerHTML = '';
    
    tattoos.forEach(tattoo => {
        const card = document.createElement('div');
        card.className = 'tattoo-card';
        card.onclick = () => selectTattoo(tattoo);
        
        card.innerHTML = `
            <div class="tattoo-preview">🎨</div>
            <div class="tattoo-name">${tattoo.name}</div>
            <div class="tattoo-price">$${tattoo.price}</div>
        `;
        
        grid.appendChild(card);
    });
    
    document.getElementById('tattoo-view').classList.remove('hidden');
    document.getElementById('category-view').classList.add('hidden');
    document.getElementById('confirm-view').classList.add('hidden');
}

// Select tattoo
function selectTattoo(tattoo) {
    selectedTattoo = tattoo;
    
    // Show confirmation
    document.getElementById('confirm-name').textContent = tattoo.name;
    document.getElementById('confirm-price').textContent = `$${tattoo.price}`;
    
    document.getElementById('confirm-view').classList.remove('hidden');
    document.getElementById('tattoo-view').classList.add('hidden');
    
    // Send preview request
    fetch(`https://${GetParentResourceName()}/previewTattoo`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
            targetId: targetPlayerId,
            tattoo: tattoo 
        })
    });
}

// Confirm tattoo
function confirmTattoo() {
    if (!selectedTattoo) return;
    
    fetch(`https://${GetParentResourceName()}/confirmTattoo`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
            targetId: targetPlayerId,
            tattoo: selectedTattoo 
        })
    });
    
    closeUI();
}

// Show views
function showCategoryView() {
    document.getElementById('category-view').classList.remove('hidden');
    document.getElementById('tattoo-view').classList.add('hidden');
    document.getElementById('confirm-view').classList.add('hidden');
    
    // Clear preview
    if (selectedTattoo) {
        fetch(`https://${GetParentResourceName()}/clearPreview`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ targetId: targetPlayerId })
        });
        selectedTattoo = null;
    }
}

function showTattooView() {
    document.getElementById('tattoo-view').classList.remove('hidden');
    document.getElementById('confirm-view').classList.add('hidden');
    
    // Clear preview
    if (selectedTattoo) {
        fetch(`https://${GetParentResourceName()}/clearPreview`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ targetId: targetPlayerId })
        });
        selectedTattoo = null;
    }
}
