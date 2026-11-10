console.log("APP CARREGADO");

const habits = [];

function renderHabits() {

    const container =
        document.getElementById("habitsContainer");

    if (!container) return;

    container.innerHTML = "";

    habits.forEach((habit) => {

        const row =
            document.createElement("div");

        row.style.marginBottom = "20px";

        let dias = "";

        for (let i = 1; i <= 30; i++) {

            dias += `
                <label style="margin-right:8px;">
                    <input type="checkbox">
                    ${i}
                </label>
            `;
        }

        row.innerHTML = `
            <h3>${habit.name}</h3>
            <div>${dias}</div>
            <hr>
        `;

        container.appendChild(row);
    });
}

document.addEventListener("DOMContentLoaded", () => {

    const btn =
        document.getElementById("addHabitBtn");

    btn.addEventListener("click", () => {

        const input =
            document.getElementById("habitInput");

        const nome =
            input.value.trim();

        if (!nome) return;

        habits.push({
            name: nome
        });

        input.value = "";

        renderHabits();

        console.log("Adicionado:", nome);
    });

});