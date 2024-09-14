import React, { useEffect, useState } from 'react';
import { Container, Form, Button, Nav, Navbar, Alert } from 'react-bootstrap';
import { useSearchParams } from 'react-router-dom';

function UserSettingsPage() {
  const [searchParams] = useSearchParams();
  const clientId = searchParams.get('id');
  const [formData, setFormData] = useState(null);
  const [originalData, setOriginalData] = useState(null);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  useEffect(() => {
    fetch(`http://localhost:8080/api/v1/clients/${clientId}`)
      .then((res) => {
        if (!res.ok) {
          throw new Error('Клиент не найден.');
        }
        return res.json();
      })
      .then((data) => {
        setFormData({ ...data.clientData });
        setOriginalData({ ...data.clientData });
      })
      .catch((err) => setError(err.message));
  }, [clientId]);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleReset = () => {
    setFormData(originalData);
    setError('');
    setSuccess('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');

    // Определяем измененные поля
    const updatedFields = {};
    for (let key in formData) {
      if (formData[key] !== originalData[key]) {
        updatedFields[key] = formData[key];
      }
    }

    if (Object.keys(updatedFields).length === 0) {
      setError('Нет изменений для сохранения.');
      return;
    }

    try {
      const response = await fetch(`http://localhost:8080/api/v1/clients/${clientId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(updatedFields),
      });

      if (!response.ok) {
        const errorData = await response.json();
        setError(`Ошибка: ${errorData.message || 'Не удалось сохранить изменения.'}`);
        return;
      }

      setSuccess('Данные успешно сохранены.');
      setOriginalData({ ...formData });
    } catch (err) {
      setError('Произошла ошибка при сохранении данных.');
    }
  };

  if (error) {
    return (
      <Container className="mt-5">
        <Alert variant="danger">{error}</Alert>
      </Container>
    );
  }

  if (!formData) {
    return null;
  }

  return (
    <>
      <Navbar bg="light">
        <Container>
          <Navbar.Brand href="/">Kivi Wallet</Navbar.Brand>
          <Nav>
            <Nav.Link href={`/lk?id=${clientId}`}>Главная страница пользователя</Nav.Link>
            <Nav.Link href={`/payments?id=${clientId}`}>Платежи</Nav.Link>
            <Nav.Link href="/">Выход</Nav.Link>
          </Nav>
        </Container>
      </Navbar>
      <Container className="mt-5">
        <h2>Настройки пользователя</h2>
        {success && <Alert variant="success">{success}</Alert>}
        <Form onSubmit={handleSubmit}>
          {/* Поля формы */}
          <Form.Group controlId="lastName">
            <Form.Label>Фамилия</Form.Label>
            <Form.Control
              type="text"
              name="lastName"
              value={formData.lastName || ''}
              onChange={handleChange}
            />
          </Form.Group>

          <Form.Group controlId="firstName">
            <Form.Label>Имя</Form.Label>
            <Form.Control
              type="text"
              name="firstName"
              value={formData.firstName || ''}
              onChange={handleChange}
            />
          </Form.Group>

          <Form.Group controlId="sureName">
            <Form.Label>Отчество</Form.Label>
            <Form.Control
              type="text"
              name="sureName"
              value={formData.sureName || ''}
              onChange={handleChange}
            />
          </Form.Group>

          <Form.Group controlId="birthDay">
            <Form.Label>Дата рождения</Form.Label>
            <Form.Control
              type="date"
              name="birthDay"
              value={formData.birthDay || ''}
              onChange={handleChange}
            />
          </Form.Group>

          <Form.Group controlId="email">
            <Form.Label>Email</Form.Label>
            <Form.Control
              type="email"
              name="email"
              value={formData.email || ''}
              onChange={handleChange}
            />
          </Form.Group>

          <Form.Group controlId="inn">
            <Form.Label>ИНН</Form.Label>
            <Form.Control
              type="text"
              name="inn"
              value={formData.inn || ''}
              onChange={handleChange}
            />
          </Form.Group>

          <Form.Group controlId="mobilePhone">
            <Form.Label>Мобильный телефон</Form.Label>
            <Form.Control
              type="text"
              name="mobilePhone"
              value={formData.mobilePhone || ''}
              onChange={handleChange}
            />
          </Form.Group>

          <Button variant="secondary" onClick={handleReset} className="mt-3 me-2">
            Сбросить
          </Button>
          <Button variant="primary" type="submit" className="mt-3">
            Сохранить
          </Button>
        </Form>
      </Container>
    </>
  );
}

export default UserSettingsPage;
