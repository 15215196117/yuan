package main

import (
	"fmt"
	"time"
)

func get_sum_of_divisible(num int, divider int, resultChan chan int) {
	sum := 0
	for value := 0; value < num; value++ {
		if value%divider == 0 {
			sum += value
		}
	}
	resultChan <- sum
}

func main() {
	LIMIT := 10
	resultChan := make(chan int, 3)
	t_start := time.Now()
	go get_sum_of_divisible(LIMIT, 3, resultChan)
	go get_sum_of_divisible(LIMIT, 5, resultChan)
	//这里其实那个是被3整除，哪个是被5整除看具体调度方法，不过由于是求和，所以没关系
	sum3, sum5 := <-resultChan, <-resultChan

	//单独算被15整除的
	go get_sum_of_divisible(LIMIT, 15, resultChan)
	sum15 := <-resultChan

	sum := sum3 + sum5 - sum15
	t_end := time.Now()
	fmt.Println(sum)
	fmt.Println(t_end.Sub(t_start))
}