package com.example.employee.controller;

import com.example.employee.model.Employee;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/employees")
public class EmployeeController {

    private final List<Employee> employees = new ArrayList<>();

    @GetMapping
    public List<Employee> getAllEmployees() {
        return employees;
    }

    @PostMapping
    public Employee addEmployee(@RequestBody Employee employee) {
        employees.add(employee);
        return employee;
    }

    @DeleteMapping("/{id}")
    public String deleteEmployee(@PathVariable Long id) {
        employees.removeIf(emp -> emp.getId().equals(id));
        return "Employee removed successfully";
    }
}
