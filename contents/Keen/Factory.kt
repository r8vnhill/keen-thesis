genotype {
    repeat(meetings.size) {
        chromosome {
            ints { 
              size = 1
              range = meetings.indices.first to meetings.indices.last 
            }
        }
    }
}