# Flutter Services Package
Flutter services package for Limbitless Team Website

## Overview

This Flutter application provides functionalities for creating and tracking orders. The app has two primary pages:

## Features

- **Home Page**: Features buttons to navigate to the Create Order and Track Order pages. The page uses a blueGrey background with white buttons.
- **Create Order Page**: Allows users to input details such as process, unit, type, quantity, and rate, and submit the order with file attachment support.
- **Track Order Page**: Users can track their order by entering an order ID, and view the order details and status updates.

## Directory Structure

*lib/*:
- *main.dart*: Entry point of the app.
- *home_page.dart*: Home page layout and functionality.
- *create_order_page.dart*: Create order page layout and functionality.
- *track_order_page.dart*: Track order page layout and functionality.
- *order_details.dart*: Model for order details.
- *new_order.dart*: Model for new orders.
- *save_file.dart*: Service for saving files.
- *submit_order.dart*: Service for submitting orders.
- *global_order_details.dart*: Global variable for order details.

## Styling and Design (in progress)

**Color Palette**:
- *Background*: Colors.blueGrey.shade100
- *Buttons*: White background, blue border, dark blue text.
- *AppBar*: blueGrey with white text.
**Typography**:
- *Font Color*: Dark blue for button text, black for general text.

## Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/your-username/service_package.git
   cd project

## Acknowledgments

- *Flutter Team*: For providing the framework.
- *Open-Source Community*: For the libraries and tools used in this project.
