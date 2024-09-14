import React, { useEffect, useState } from 'react';
import { Container, Table, Nav, Navbar, Alert, Form, Button } from 'react-bootstrap';
import { useSearchParams } from 'react-router-dom';

function UserPaymentsPage() {
  const [searchParams] = useSearchParams();
  const clientId = searchParams.get('id');
  const [payments, setPayments] = useState([]);
  const [error, setError] = useState('');
  const [formError, setFormError] = useState('');
  const [successMessage, setSuccessMessage] = useState('');

  // Новое состояние для формы создания платежа
  const [paymentForm, setPaymentForm] = useState({
    toClientId: '',
    summa: '',
    currencyId: '',
    note: '',
  });

  useEffect(() => {
    fetchPayments();
  }, [clientId]);

  const fetchPayments = () => {
    fetch(`http://localhost:8080/api/v1/payments/?clientId=${clientId}`)
      .then((res) => res.json())
      .then((data) => setPayments(data))
      .catch((err) => setError('Не удалось загрузить платежи.'));
  };

  const handleFormChange = (e) => {
    setPaymentForm({ ...paymentForm, [e.target.name]: e.target.value });
  };

  const handleFormReset = () => {
    setPaymentForm({
      toClientId: '',
      summa: '',
      currencyId: '',
      note: '',
    });
    setFormError('');
    setSuccessMessage('');
  };

  const handleFormSubmit = async (e) => {
    e.preventDefault();
    setFormError('');
    setSuccessMessage('');

    // Валидация полей формы
    if (!paymentForm.toClientId || !paymentForm.summa || !paymentForm.currencyId) {
      setFormError('Пожалуйста, заполните все обязательные поля.');
      return;
    }

    const payload = {
      fromClientId: clientId,
      toClientId: paymentForm.toClientId,
      currencyId: parseInt(paymentForm.currencyId),
      summa: parseFloat(paymentForm.summa),
      paymentDetail: {
        note: paymentForm.note,
      },
    };

    try {
      const response = await fetch('http://localhost:8080/api/v1/payments/', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });

      if (!response.ok) {
        const errorData = await response.json();
        setFormError(`Ошибка: ${errorData.message || 'Не удалось создать платеж.'}`);
        return;
      }

      const data = await response.json();
      setSuccessMessage(`Успешно создан платеж с ID=${data.paymentId}.`);
      handleFormReset();
      fetchPayments(); // Обновляем список платежей
    } catch (err) {
      setFormError('Произошла ошибка при создании платежа.');
    }
  };

  if (error) {
    return (
      <Container className="mt-5">
        <Alert variant="danger">{error}</Alert>
      </Container>
    );
  }

  return (
    <>
      <Navbar bg="light">
        <Container>
          <Navbar.Brand href="/">Kivi Wallet</Navbar.Brand>
          <Nav>
            <Nav.Link href={`/lk?id=${clientId}`}>Главная страница пользователя</Nav.Link>
            <Nav.Link href={`/prop?id=${clientId}`}>Настройки</Nav.Link>
            <Nav.Link href="/">Выход</Nav.Link>
          </Nav>
        </Container>
      </Navbar>
      <Container className="mt-5">
        <h2>Создание платежа</h2>
        {formError && <Alert variant="danger">{formError}</Alert>}
        {successMessage && <Alert variant="success">{successMessage}</Alert>}
        <Form onSubmit={handleFormSubmit}>
          <Form.Group controlId="toClientId">
            <Form.Label>ID клиента для оплаты</Form.Label>
            <Form.Control
              type="text"
              name="toClientId"
              value={paymentForm.toClientId}
              onChange={handleFormChange}
              required
            />
          </Form.Group>

          <Form.Group controlId="summa">
            <Form.Label>Сумма</Form.Label>
            <Form.Control
              type="number"
              step="0.01"
              name="summa"
              value={paymentForm.summa}
              onChange={handleFormChange}
              required
            />
          </Form.Group>

          <Form.Group controlId="currencyId">
            <Form.Label>Код валюты</Form.Label>
            <Form.Control
              type="text"
              name="currencyId"
              value={paymentForm.currencyId}
              onChange={handleFormChange}
              required
            />
          </Form.Group>

          <Form.Group controlId="note">
            <Form.Label>Примечание</Form.Label>
            <Form.Control
              as="textarea"
              name="note"
              value={paymentForm.note}
              onChange={handleFormChange}
            />
          </Form.Group>

          <Button variant="primary" type="submit" className="mt-3 me-2">
            Отправить платеж
          </Button>
          <Button variant="secondary" onClick={handleFormReset} className="mt-3">
            Сбросить
          </Button>
        </Form>

        <hr className="my-5" />

        <h2>Платежи пользователя</h2>
        <Table striped bordered hover>
          <thead>
            <tr>
              <th>Id платежа</th>
              <th>Дата платежа</th>
              <th>Сумма платежа</th>
              <th>Валюта</th>
              <th>Примечание</th>
              <th>Статус платежа</th>
            </tr>
          </thead>
          <tbody>
            {payments.length === 0 ? (
              <tr>
                <td colSpan="6" className="text-center">
                  Нет платежей
                </td>
              </tr>
            ) : (
              payments
                .sort((a, b) => new Date(b.createDateTime) - new Date(a.createDateTime))
                .map((payment) => (
                  <tr key={payment.id}>
                    <td>{payment.id}</td>
                    <td>{new Date(payment.createDateTime).toLocaleString()}</td>
                    <td>{payment.summa}</td>
                    <td>{payment.currencyId}</td>
                    <td>{payment.paymentDetail?.note}</td>
                    <td>{payment.status}</td>
                  </tr>
                ))
            )}
          </tbody>
        </Table>
      </Container>
    </>
  );
}

export default UserPaymentsPage;
