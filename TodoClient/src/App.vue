<script setup>
import { ethers } from "ethers";
import { ref } from 'vue';
import Todoabi from '../../artifacts/contracts/Todolist.sol/Todolist.json'
//import Todoabi from 'artifacts\contracts\Todolist.sol\Todolist.json';
const con = ref();
const count = ref();
let wallet='';
let provider='';
const task=ref('');
const tasks=ref([]);
const load = ref(false);

async function connect(){
  if(window.ethereum){
  provider = new ethers.BrowserProvider(window.ethereum);
  wallet = await provider.getSigner();
  await window.ethereum.request({
  "method": "wallet_switchEthereumChain",
  "params": [
    {
      "chainId": "0xAA36A7"
    }
  ]
});
  await wallet.signMessage("Welcome to Raj's Todo Dapp for using this App, You would be needing some Sepolia ETH in your wallet, which you could get from here https://sepoliafaucet.com/");
  con.value = true;
  const todo = await new ethers.Contract("0xBA48a0aF78381C573Ed01e36b08021BaF59cbAee",Todoabi.abi, wallet);
  if(con.value){
    count.value = await todo.actual_count();
    count.value = parseInt(count.value.toString());
    for(let i=1;i<=count.value;i++)
    {
      tasks.value.push(await todo.tasks(wallet.address,i));
    }
  }
}
else{
  console.log("Please Install a Wallet");
}
}

async function add(){
  const todo = await new ethers.Contract("0xBA48a0aF78381C573Ed01e36b08021BaF59cbAee",Todoabi.abi, wallet);
  await wallet.signMessage(`You are adding a New Task ${task.value}`);
  const adding = await todo.create_task(task.value);
  load.value = true;
  await adding.wait();
  //window.location.reload();
  count.value = await todo.actual_count(); // LATEST
  tasks.value.push(await todo.tasks(wallet.address,count.value));
  load.value = false;
  task.value='';
}

async function toggle(id){
  const todo = await new ethers.Contract("0xBA48a0aF78381C573Ed01e36b08021BaF59cbAee",Todoabi.abi, wallet);
  const tx = await todo.check(id);
  await tx.wait();
  //window.location.reload();
  count.value = await todo.actual_count();
  tasks.value = []
  for(let i=1;i<=count.value;i++)
    {
      tasks.value.push(await todo.tasks(wallet.address,i));
    }
}

</script>

<template>
  <div>
    <h1>Decentralized To-Do Application</h1>
    <div v-if="con">
      <button type="button" class="btn btn-success">Wallet Connected Successfully!</button>
      <p> Address of the Connected Wallet : {{ wallet.address }}</p><br>
      <!-- <button type="button" v-on:click="main()" class="btn btn-info">Click Me</button> -->
      <div class="input-group">
        <div class="input-group-prepend">
          <div v-if="task">
            <button type="button" v-on:click="add()" class="btn btn-info">ADD TASK</button>
          </div>
          <div v-else>
            <button type="button" v-on:click="add()" class="btn btn-info" disabled>ADD TASK</button>
          </div>
        <input v-model="task" type="text" placeholder="Add New Task" class="form-control">
      </div>
  </div>
  <br><br><br>
  <h2> TASKS :</h2> <br><br>
  <div v-if="tasks.length==0"><p> NO TASKS YET!</p></div>
  <ul v-for="t in tasks">
    <input type="checkbox" :checked="t[2]" v-on:click="toggle(t[0])">
    <span :style="{ 'text-decoration': t[2] ? 'line-through' : 'none' }">{{ t[1] }}</span>
  </ul><br>
  <p v-if="load"> LOADING </p>
    </div>
    <div v-else>
      <button type="button" v-on:click="connect()" class="btn btn-primary">Connect Wallet</button>
    </div>
  </div>

</template>

<style scoped>
.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>
