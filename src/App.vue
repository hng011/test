<template>
  <div class="todo-container">
    <!-- Add-task row -->
    <div class="todo-input-row">
      <input
        v-model="newTask"
        type="text"
        placeholder="What needs to be done?"
        @keyup.enter="addTask"
      />
      <button @click="addTask">Add</button>
    </div>

    <!-- Task list -->
    <ul class="todo-list">
      <li
        v-for="task in tasks"
        :key="task.id"
        :class="{ completed: task.completed }"
        @click="toggleTask(task)"
      >
        <span>{{ task.text }}</span>
        <button class="delete-btn" @click.stop="removeTask(task.id)">Delete</button>
      </li>
    </ul>
  </div>
</template>

<script setup>
// Migrated from app.js: Vue 3 task list state and actions.
import { ref } from 'vue';

// In-memory task data.
const tasks = ref([
  { id: 1, text: 'Learn Vue', completed: true },
  { id: 2, text: 'Build a task list', completed: false },
]);

// Input binding (v-model="newTask").
const newTask = ref('');

function addTask() {
  const text = newTask.value.trim();
  if (!text) return;
  tasks.value.push({
    id: Date.now(),
    text,
    completed: false,
  });
  newTask.value = '';
}

function toggleTask(task) {
  task.completed = !task.completed;
}

function removeTask(id) {
  tasks.value = tasks.value.filter((task) => task.id !== id);
}
</script>

<style scoped>
/* Migrated from styles.css: minimal styling for the Vue task list. */

/* --- Todo container --- */
.todo-container {
  max-width: 400px;
  margin: 40px auto;
  padding: 20px;
  font-family: Arial, Helvetica, sans-serif;
  border: 1px solid #ddd;
  border-radius: 6px;
  background: #fff;
}

/* --- Input and add button row --- */
.todo-input-row {
  display: flex;
  gap: 8px;
  margin-bottom: 16px;
}

.todo-input-row input {
  flex: 1;
  padding: 8px;
  font-size: 14px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.todo-input-row button {
  padding: 8px 16px;
  font-size: 14px;
  border: none;
  border-radius: 4px;
  background: #007bff;
  color: #fff;
  cursor: pointer;
}

.todo-input-row button:hover {
  background: #0056b3;
}

/* --- Task list --- */
.todo-list {
  list-style: none;
  margin: 0;
  padding: 0;
}

.todo-list li {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px solid #eee;
  cursor: pointer;
}

.todo-list li:last-child {
  border-bottom: none;
}

/* --- Completed state --- */
.todo-list li.completed span {
  text-decoration: line-through;
  color: #999;
}

/* --- Delete button --- */
.delete-btn {
  padding: 4px 10px;
  font-size: 12px;
  border: 1px solid #ccc;
  border-radius: 4px;
  background: #f8f8f8;
  color: #c00;
  cursor: pointer;
}

.delete-btn:hover {
  background: #c00;
  color: #fff;
}
</style>
