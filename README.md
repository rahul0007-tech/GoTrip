# GoTrip
## Business Rule

### 1. **Admin**

- **Properties**:
    - **ID**: Unique identifier (auto-generated, mandatory)
    - **Name**: Admin's full name (mandatory)
    - **Email**: Admin's email (must be unique, mandatory)
    - **Password**: Admin's login password (mandatory)
- **Uniqueness**:
    - Each admin has a **unique email**.
- **Optional/Mandatory**:
    - All fields (ID, name, email, password) are **mandatory**.
- **Relationships**:
    - Admin can **view**, create, **edit**, **verify**, or **delete** **passengers**, **drivers**, and **vehicles** (one-to-many relationship).
    - Admin can **view ride status** and **handle payments**.

---

### 2. **Passenger**

- **Properties**:
    - **ID**: Unique identifier (auto-generated, mandatory)
    - **Name**: Passenger’s full name (mandatory)
    - **Email**: Passenger's email (must be unique, mandatory)
    - **Phone Number**: Passenger's contact number (must be unique, mandatory)
    - **Password**: Passenger’s login password (mandatory)
    - **Profile Image**: Passenger’s profile picture (optional)
- **Uniqueness**:
    - **Email** and **phone number** must be **unique**.
- **Optional/Mandatory**:
    - **Name, email, phone number, and password** are **mandatory** for sign-up.
    - **Profile image** is **optional**.
    - Rating vehicles is **optional**.
    - Editing profile is optional
- **Relationships**:
    - A passenger can have multiple **bookings** (one-to-many relationship with bookingIntegrity ⇒s).
    - Passenger **requests bookings** with a specific driver and vehicle (many-to-one relationship with drivers and vehicles).

---

### 3. **Driver**

- **Properties**:
    - **ID**: Unique identifier (auto-generated, mandatory)
    - **Name**: Driver’s full name (mandatory)
    - **Phone Number**: Driver's contact number (must be unique, mandatory)
    - **Email**: Driver’s email (must be unique, mandatory)
    - **License Image**: A photo of the driver’s license (mandatory)
    - **Password**: Driver’s login password (mandatory)
    - **Status**: Busy/Vacant toggle bar (mandatory)
- **Uniqueness**:
    - **Email**, **phone number**, and **license** must be **unique**.
- **Optional/Mandatory**:
    - All fields are **mandatory** for registering in the system.
    - **Status** (busy/vacant) is a **mandatory toggle** for booking availability.
- **Relationships**:
    - A driver can have **only one vehicle** (one-to-one relationship).
    - A driver can handle multiple bookings (one-to-many relationship with bookings).
    - Drivers must provide car details in a separate form.

---

### 4. **Vehicle**

- **Properties**:
    - **ID**: Unique identifier (auto-generated, mandatory)
    - **Car Image**: Image of the vehicle (mandatory)
    - **Color**: Color of the vehicle (mandatory)
    - **Company**: Vehicle manufacturer (mandatory)
    - **Vehicle Type**: Type of vehicle (SUV, sedan, etc.) (mandatory)
    - **Fuel Type**: Petrol, diesel, electric, etc. (mandatory)
    - **Seating Capacity**: Number of seats in the vehicle (mandatory)
    - **Vehicle Number**: Registration number (must be unique, mandatory)
    - **DriverID:** Foreign key of drivers id(mandatory)
- **Uniqueness**:
    - **Vehicle number** must be **unique**.
- **Optional/Mandatory**:
    - All fields are **mandatory** for registering a vehicle.
- **Relationships**:
    - A vehicle belongs to **exactly one driver** (one-to-one relationship).
    - A vehicle can be used for multiple bookings (one-to-many relationship with bookings).

---

### 5. **booking**

- **Properties**:
    - **booking ID**: Unique identifier (auto-generated, mandatory)
    - **passenger ID:** A reference to passenger(mandatory)
    - **Driver ID:** A reference to drivers(optional)
    - **Pickup Point**: Location where the passenger will be picked up (mandatory)
    - **Destination**: booking destination (mandatory)
    - **Booking Date**: Time the booking was booked (mandatory)
    - **booking Status**: Pending, In Progress, Completed (mandatory)
    - **Payment Status**: Pending, Paid (mandatory)
    - **Amount Paid**: Amount paid by the passenger (mandatory, with 10% upfront)
- **Uniqueness**:
    - **booking ID** is unique to each booking.
- **Optional/Mandatory**:
    - **Pickup point, destination, booking status, and payment status** are **mandatory** for booking creation.
    - **Booking Date** must be in present or future.
- **Relationships**:
    - Each **booking** is associated with a single **passenger** and **driver** (many-to-one relationship).
    - A booking is tied to a specific **vehicle** (many-to-one relationship).

---

### 6. **Payment**

- **Properties**:
    - **Payment ID**: Unique identifier (auto-generated, mandatory)
    - **booking ID**: Reference to the related booking (mandatory)
    - **Amount Paid**: Amount paid by the passenger (mandatory)
    - **Payment Date**: Date the payment was made (auto-generated, mandatory)
    - **Payment Status**: Paid or Pending (mandatory)
- **Uniqueness**:
    - **Payment ID** is unique.
- **Optional/Mandatory**:
    - All fields are **mandatory**.
- **Relationships**:
    - Each payment is tied to one **booking**, **passenger**, and **driver** (many-to-one relationship).
 
  ---

### **7. Ratings**

**Properties**:

- **Rating ID**: Unique identifier for the rating (auto-generated, mandatory)
- **booking ID**: Reference to the related booking (mandatory)
- **Rating Score**: Numerical rating (e.g., 1-5 stars) provided by the passenger (mandatory)
- **Rating Date**: Date the rating was submitted (auto-generated, mandatory)

**Uniqueness**:

- **Rating ID** is unique.
- A passenger can only provide **one rating per booking**.

**Optional/Mandatory**:

- All fields are **mandatory**.

**Relationships**:

- Each **rating** is tied to one **booking**, **passenger**, **driver**, and **vehicle** (many-to-one relationship).
