import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import MainPage from './pages/MainPage';
import RegistrationPage from './pages/RegistrationPage';
import UserHomePage from './pages/UserHomePage';
import UserSettingsPage from './pages/UserSettingsPage';
import UserPaymentsPage from './pages/UserPaymentsPage';
import LoginPage from './pages/LoginPage'; // Добавьте этот импорт

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<MainPage />} />
        <Route path="/reg" element={<RegistrationPage />} />
        <Route path="/login" element={<LoginPage />} /> {/* Новый маршрут */}
        <Route path="/lk" element={<UserHomePage />} />
        <Route path="/prop" element={<UserSettingsPage />} />
        <Route path="/payments" element={<UserPaymentsPage />} />
      </Routes>
    </Router>
  );
}

export default App;
