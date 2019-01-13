workflow "New workflow" {
  on = "push"
  resolves = ["Run Tests"]
}

action "Run Tests" {
  uses = "./"
}
