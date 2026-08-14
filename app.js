// Vue task list application.
// Expects Vue 3 (global build) to be loaded before this script,
// and an element with id="app" in the page.

const { createApp, ref } = Vue;

createApp({
  setup() {
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

    return {
      tasks,
      newTask,
      addTask,
      toggleTask,
      removeTask,
    };
  },
}).mount('#app');
