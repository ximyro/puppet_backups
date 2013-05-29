class schedules{
  schedule { 'maint':
   range  => "2 - 4",
   period => daily,
   repeat => 1,
  }
}
