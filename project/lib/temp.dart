/*body: Container
      (
        color: const Color(0xFFEEEEEE),
        padding: const EdgeInsets.all(16.0),
        child: Form
        (
          key: _formKey,
          child: Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [            
              Row
              (
                children: 
                [
                  // "Enter Your Name" Section
                  Expanded
                  (
                    child: TextFormField
                    (
                      controller: _nameController,
                      decoration: const InputDecoration
                      (
                        labelText: 'Enter Your Name',
                        labelStyle: TextStyle
                        (
                          color: Color(0xFF000000),
                          fontFamily: 'Klavika',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      style: const TextStyle(color: Color(0xFF000000)),
                      validator: (value) 
                      {
                        if (value == null || value.isEmpty) 
                        {
                          return 'Please fill out the name field!';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0), // Spacing between fields

                  // "Journal Transfer Number" Section
                  Expanded
                  (
                    child: TextFormField
                    (
                      controller: _journalNumController,
                      decoration: const InputDecoration
                      (
                        labelText: 'Journal Transfer Number',
                        labelStyle: TextStyle
                        (
                          color: Color(0xFF000000),
                          fontFamily: 'Klavika',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      style: const TextStyle(color: Color(0xFF000000)),
                      validator: (value) 
                      {
                        if (value == null || value.isEmpty) 
                        {
                          return 'Please enter the journal transfer number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0), // Spacing between fields

                  // "Department" Section
                  Expanded
                  (
                    child: TextFormField
                    (
                      controller: _departmentController,
                      decoration: const InputDecoration
                      (
                        labelText: 'Department',
                        labelStyle: TextStyle
                        (
                          color: Color(0xFF000000),
                          fontFamily: 'Klavika',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      style: const TextStyle(color: Color(0xFF000000)),
                      validator: (value) 
                      {
                        if (value == null || value.isEmpty) 
                        {
                          return 'Please enter the department';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // "Pick a File" Section
              ElevatedButton(
                onPressed: _pickFile,
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0)), // Reduced padding
                  backgroundColor: WidgetStateProperty.all(const Color(0xFFFFFFFF)),
                  foregroundColor: WidgetStateProperty.all(const Color(0xFF2A94D4)), // Button text color
                  side: WidgetStateProperty.all(const BorderSide(width: 2.0, color: Color(0xFF2A94D4))), // Button border color
                  minimumSize: WidgetStateProperty.all(const Size(100, 36)), // Minimum size for smaller button
                ),
                child: const Text(
                  'Pick a File',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Klavika',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_filePath != null)
                Text(
                  'Selected file: $_filePath',
                  style: const TextStyle(color: Color(0xFF000000)),
                ),
              const SizedBox(height: 12.0),

              Expanded(
                child: SingleChildScrollView(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Check if the screen width is less than a certain value (e.g., 600 pixels)
                        bool isMobile = constraints.maxWidth < 600;

                        return Column(
                          children: [
                            if (isMobile)
                              // Mobile view: Stack containers vertically
                              Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0xFF707070),
                                          spreadRadius: 1,
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        DropdownButtonFormField<String>(
                                          value: _selectedProcess,
                                          decoration: const InputDecoration(
                                            labelText: 'Select Process',
                                            labelStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF000000),
                                              fontFamily: 'Klavika',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xFF000000),
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                          items: ['Thermoforming', '3D Printing', 'Milling']
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedProcess = newValue!;
                                              _calculateRate();
                                            });
                                          },
                                        ),
                                        DropdownButtonFormField<String>(
                                          value: _selectedUnit,
                                          decoration: const InputDecoration(
                                            labelText: 'Select Unit',
                                            labelStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF000000),
                                              fontFamily: 'Klavika',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xFF000000),
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                          items: ['mm', 'cm', 'inches'].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedUnit = newValue!;
                                              _calculateRate();
                                            });
                                          },
                                        ),
                                        DropdownButtonFormField<String>(
                                          value: _selectedType,
                                          decoration: const InputDecoration(
                                            labelText: 'Select Type',
                                            labelStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF000000),
                                              fontFamily: 'Klavika',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xFF000000),
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                          items: ['Aluminum', 'Steel', 'Brass'].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedType = newValue!;
                                              _calculateRate();
                                            });
                                          },
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Enter Quantity',
                                            labelStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF000000),
                                              fontFamily: 'Klavika',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                          initialValue: '1',
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xFF000000),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a quantity';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _quantity = int.tryParse(value) ?? 1;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          'Rate: $_rate per cubic unit',
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xFF000000),
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0xFF707070),
                                          spreadRadius: 1,
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Process: $_selectedProcess',
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Color(0xFF000000),
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'Unit: $_selectedUnit',
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Color(0xFF000000),
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'Type: $_selectedType',
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Color(0xFF000000),
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'Quantity: $_quantity',
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Color(0xFF000000),
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'Rate: $_rate per cubic unit',
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Color(0xFF000000),
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          'Estimated Price: \$${(_volume * _rate * _quantity).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Color(0xFF000000),
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        const Text(
                                          'Estimated Delivery:',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Color(0xFF000000),
                                            fontFamily: 'Klavika',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              )
                            else
                              // Desktop view: Stack containers side by side
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFFFF),
                                        borderRadius: BorderRadius.circular(8.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0xFF707070),
                                            spreadRadius: 1,
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          DropdownButtonFormField<String>(
                                            value: _selectedProcess,
                                            decoration: const InputDecoration(
                                              labelText: 'Select Process',
                                              labelStyle: TextStyle(
                                                fontSize: 16.0,
                                                color: Color(0xFF000000),
                                                fontFamily: 'Klavika',
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF000000),
                                              fontFamily: 'Klavika',
                                              fontWeight: FontWeight.normal,
                                            ),
                                            items: ['Thermoforming', '3D Printing', 'Milling']
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                _selectedProcess = newValue!;
                                                _calculateRate();
                                              });
                                            },
                                          ),
                                          DropdownButtonFormField<String>(
                                            value: _selectedUnit,
                                            decoration: const InputDecoration(
                                              labelText: 'Select Unit',
                                              labelStyle: TextStyle(
                                                fontSize: 16.0,
                                                color: Color(0xFF000000),
                                                fontFamily: 'Klavika',
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF000000),
                                              fontFamily: 'Klavika',
                                              fontWeight: FontWeight.normal,
                                            ),
                                            items: ['mm', 'cm', 'inches'].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                _selectedUnit = newValue!;
                                                _calculateRate();
                                              });
                                            },
                                          ),
                                          DropdownButtonFormField<String>(
                                            value: _selectedType,
                                            decoration: const InputDecoration(
                                              labelText: 'Select Type',
                                              labelStyle: TextStyle(
                                                fontSize: 16.0,
                                                color: Color(0xFF000000),
                                                fontFamily: 'Klavika',
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF000000),
                                              fontFamily: 'Klavika',
                                              fontWeight: FontWeight.normal,
                                            ),
                                            items: ['Aluminum', 'Steel', 'Brass'].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                _selectedType = newValue!;
                                                _calculateRate();
                                              });
                                            },
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Enter Quantity',
                                              labelStyle: TextStyle(
                                                fontSize: 16.0,
                                                color: Color(0xFF000000),
                                                fontFamily: 'Klavika',
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                            initialValue: '1',
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF000000),
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter a quantity';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                _quantity = int.tryParse(value) ?? 1;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            'Rate: $_rate per cubic unit',
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Color(0xFF000000),
                                              fontFamily: 'Klavika',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFFFF),
                                        borderRadius: BorderRadius.circular(8.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0xFF707070),
                                            spreadRadius: 1,
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Process: $_selectedProcess',
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              color: Color(0xFF000000),
                                              fontFamily: 'Klavika',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            'Unit: $_selectedUnit',
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              color: Color(0xFF000000),
                                              fontFamily: 'Klavika',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            'Type: $_selectedType',
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              color: Color(0xFF000000),
                                              fontFamily: 'Klavika',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            'Quantity: $_quantity',
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              color: Color(0xFF000000),
                                              fontFamily: 'Klavika',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            'Rate: $_rate per cubic unit',
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              color: Color(0xFF000000),
                                              fontFamily: 'Klavika',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            'Estimated Price: \$${(_volume * _rate * _quantity).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              color: Color(0xFF000000),
                                              fontFamily: 'Klavika',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          const Text(
                                            'Estimated Delivery:',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Color(0xFF000000),
                                              fontFamily: 'Klavika',
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                onPressed: _submitOrder,
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(const Color(0xFFFFFFFF)),
                                  foregroundColor: WidgetStateProperty.all(const Color(0xFF2A94D4)), // Button text color
                                  side: WidgetStateProperty.all(const BorderSide(width: 2.0, color: Color(0xFF2A94D4))), // Button border color
                                ),
                                child: const Text(
                                  'Submit Order',
                                  style: TextStyle(
                                    fontFamily: 'Klavika',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                ),               
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

