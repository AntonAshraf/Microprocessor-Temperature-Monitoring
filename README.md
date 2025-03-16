# Microprocessor-Temperature-Monitoring

Microprocessor-based temperature monitoring system using the AT89C52 microcontroller, ADC, LCD display, and motor control. Implemented in Assembly with interrupts.

## Overview

This project implements a temperature monitoring system using the **AT89C52** microcontroller. The system reads temperature data using an **LM35 sensor**, processes it via an **ADC**, and displays the results on an **LCD**. It also controls motors based on temperature thresholds.

---

## Features

- **Temperature Measurement**: Uses the **LM35** temperature sensor.
- **ADC Conversion**: Analog temperature data is converted to digital values.
- **LCD Display**: Real-time temperature output on an LCD screen.
- **Motor Control**: Activates or deactivates motors based on temperature levels.
- **Interrupts Implementation**: Efficient system response using microcontroller interrupts.

---

## Components Used

- **Microcontroller**: AT89C52
- **Temperature Sensor**: LM35
- **LCD Display**: 16x2
- **Analog-to-Digital Converter (ADC)**: Interfacing for temperature readings
- **Motors**: Controlled based on temperature thresholds
- **Buzzer**: Alerts when temperature exceeds critical limits

---

## Code Structure

### **Main Program (main.asm)**

- Initializes **LCD, ADC, and Ports**.
- Reads **temperature** from the sensor.
- Converts temperature data and **displays** it.
- Checks predefined **temperature thresholds** and activates motors/buzzer.

### **Temperature Handling**

- **Normal**: Motor 1 ON, Motor 2 OFF.
- **High Temperature**: Motor 1 ON, Motor 2 OFF, LCD displays "HIGH".
- **Dangerous Temperature**: Motor 1 OFF, Motor 2 ON, LCD displays "DANGER".
- **Low Temperature**: Both motors OFF.

---

## Compilation & Simulation

### **Assembling the Code**

Use an **8051 assembler** to compile `main.asm` into a `.hex` file:

```sh
# Assemble the code
gpasm -p AT89C52 main.asm -o main.hex
```

### **Proteus Simulation**

1. Load the **Proteus** project file (`8051 LM35 ADC LCD.pdsprj`).
2. Attach the compiled `main.hex` file to the microcontroller.
3. Run the simulation and observe LCD temperature readings.

---

## Deliverables

- **Assembly Code** (`main.asm`)
- **HEX File** (`main.hex`)
- **Proteus Simulation File** (`8051 LM35 ADC LCD.pdsprj`)
- **Project Report** (System design and implementation details)

---

## Contributors

- **Course:** Microprocessor (CC421)
- **Instructor:** Dr. Sherif Fadel
- **Team Members:** Anton Ashraf, Marwan Hazem

---

## License

This project is for academic purposes. Feel free to modify and enhance it!
