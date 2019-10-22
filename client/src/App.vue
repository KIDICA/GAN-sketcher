<template>
  <div id="app">
    <nav class="navbar navbar-expand-lg navbar-dark static-top bg-primary">
      <div class="container-fluid p-0">
        <a class="navbar-brand rubik branding" href="#">
          <font-awesome-icon icon="palette" class="mr-2 text-warning"/>
          GAN-Sketcher
        </a>
        <button
          class="navbar-toggler"
          type="button"
          data-toggle="collapse"
          data-target="#navbarResponsive"
          aria-controls="navbarResponsive"
          aria-expanded="false"
          aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse">
          <ul class="navbar-nav ml-auto">
            <li class="nav-item">
              <router-link to="/">Home</router-link>
            </li>
            <li class="nav-item">
              <router-link to="/about">About</router-link>
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <div class="main container-fluid p-2">
      <router-view/>
    </div>
  </div>
</template>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

body {
  background: #2b2b2b;
  overflow: hidden;
}
</style>
