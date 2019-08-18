//
//  ViewController.swift
//  ExampleProject
//
//  Created by Abdur Rahim on 7/7/19.
//  Copyright © 2019 Abdur Rahim. All rights reserved.
//

import UIKit

protocol VCFinalDelegate
{
    func finishPassing(string: String)
}


class Student
{
    var name:String?
    var roll:Int?
    var address:String?
    init(name:String, roll:Int, address:String)
    {
        self.name = name
        self.roll = roll
        self.address = address
    }
    func printOnbj()
    {
        print("name : \(self.name) roll : \(self.roll) address : \(self.address)")
    }
}

class ViewController: UIViewController {
    
    func createStudentObjectsAndSort()
    {
        let students:[Student] = [Student(name: "zzzz", roll: 1080, address: "aaa"),Student(name: "ccc", roll: 1040, address: "nnn"),Student(name: "lll", roll: 1000, address: "iii"),Student(name: "oooo", roll: 1900, address: "000"),Student(name: "sss", roll: 6000, address: "bbb")]
        let descSortStudents = students.sorted
        {
            (a,b) -> Bool in
            print("a = \(a)")
            print("b = \(b)")
            if let temprolla:Int = a.roll
            {
                if let temprollb:Int = b.roll
                {
                    return temprolla < temprollb
                }
                return false
            }
            return false
            //            print(a.roll  > b.roll)
            //            return a > b
        }
        print("print unsorted values ==========")
        for student in students
        {
            student.printOnbj()
        }
        print("print sorted values ==========")
        for student in descSortStudents
        {
            student.printOnbj()
        }
    }
    
    
    
    
    var height:Float = 1.0
    {
        willSet
        {
            print(" new value \(newValue)")
            if newValue > 10.0
            {
                print("new value can not be greater than zero")
            }
        }
        didSet
        {
            
            if height > 10.0
            {
                print("invalid size specified")
                height = 10
            }
            print("old value\(oldValue)")
        }
    }
    var width:Float = 1.0
    {
        willSet
        {
            print(" new value \(newValue)")
            if newValue > 10.0
            {
                print("new value can not be greater than zero")
            }
        }
        didSet
        {
            if height > 8.0
            {
                print("invalid size specified")
                height = 8
            }
            print("old value\(oldValue)")
        }
    }
    var areaSQMT:Float
    {
        get
        {
            return height * width
        }
        set
        {
            width = areaSQMT / height
            height = areaSQMT / width
            print("width \(width) height \(height)")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.height = 11
        self.width = 10
        print("area sqmt with high value\(self.areaSQMT)")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.height = 4.63
        self.width = 4
        print("area sqmt \(self.areaSQMT)")
        let callback = CallBack()
        callback.getBoolValue(number: 8) {
            (result) -> () in
            // do stuff with the result
            print("number greater than 5 is \(result)")
        }
        callback.getBoolValue(number: 4) { (result) in
            print("number greater than 5 is \(result)")
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.simpleSort()
        self.dryRunAscSort()
        self.decendingSort()
        self.dryRunDescSort()
        self.closureDescSort()
        self.sortEvenOdd()

        self.chainingFlatMapMapFunction()

        print("Sorting objects ===============")

        self.createStudentObjectsAndSort()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func simpleSort()
    {
        print("Simple Sort Start ======================")
        let numbers:[Int] = [0,9,8,5,6,3,2,1,12,19,11,16,13,14]
        let ascendingNumbers = numbers.sorted()
        print(numbers)
        print(ascendingNumbers)
        print("Simple Sort End ======================")
    }
    func decendingSort()
    {
        print("Descending Sort Start ======================")
        let numbers:[Int] = [0,9,8,5,6,3,2,1,12,19,11,16,13,14]
        let ascendingNumbers = numbers.sorted
        {
            (a,b) -> Bool in
            return a > b
        }
        print(numbers)
        print(ascendingNumbers)
        print("Descending Sort End ======================")
    }
    func closureDescSort()
    {
        print("Descending Sort Closure Start ======================")
        
        let numbers:[Int] = [0,9,8,5,6,3,2,1,12,19,11,16,13,14]
        let descSortNumbers = numbers.sorted(by: > )
        
        print(numbers)
        print(descSortNumbers)
        print("Descending Sort Closure End ======================")
    }
    func dryRunAscSort()
    {
        print("Dry Run Sort Ascending Start ======================")
        let numbers:[Int] = [0,9,8,5,6,3,2,1,12,19,11,16,13,14]
        let ascendingNumbers = numbers.sorted
        {
            (a,b) -> Bool in
            print("a = \(a)")
            print("b = \(b)")
            print(a  < b)
            return a < b
        }
        print(numbers)
        print(ascendingNumbers)
        print("Dry Run Sort Ascending End ======================")
    }
    func dryRunDescSort()
    {
        print("Dry Run Descending Sort Start ======================")
        let numbers:[Int] = [0,9,8,5,6,3,2,1,12,19,11,16,13,14]
        let descSortNumbers = numbers.sorted
        {
            (a,b) -> Bool in
            print("a = \(a)")
            print("b = \(b)")
            print(a  > b)
            return a > b
        }
        print(numbers)
        print(descSortNumbers)
        print("Dry Run Descending Sort End ======================")
    }
    func sortEvenOdd()
    {
        print("Sort by Even Odd Start ======================")
        let numbers:[Int] = [0,9,8,5,6,3,2,1,12,19,11,16,13,14]
        let evenNumberFirst = numbers.sorted
        {
            (a,b) -> Bool in
            print("a = \(a)")
            print("b = \(b)")
            print(a  > b)
            return a % 2  == 0
        }
        print(numbers)
        print(evenNumberFirst)
        print("Dry Run Sort Even Odd End ======================")
    }
    
//  func flatMapChainingFunction()
//  {
//    let arrayInArray = [[11,12,13],[14,15,16]]
//    let newValue = arrayInArray.flatMap{$0}.filter{$0 % 2 == 0}.map{$0 * $0}.reduce(0,+)
//    print("flatMapChainingFunction \(newValue)")
//    }

    func chainingFlatMapMapFunction()
    {
        let arrayInArray = [[11,12,13],[14,15,16]]
        let newValue = arrayInArray.flatMap{$0}.map{"$\($0)"}
        print("flatMapChainingFunction \(newValue)")
    }
//    func mapOnDictionary()
//    {
//        let bookAmount = ["harrypotter":100.0, "junglebook":100.0]
//        let returnFromMap = bookAmount.map { (<#(key: String, value: Double)#>) -> T in
//            <#code#>
//        }
//
//    }
    
}

