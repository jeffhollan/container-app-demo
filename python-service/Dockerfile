FROM python:3.7-alpine
COPY requirements.txt /app/
WORKDIR /app
RUN pip install -r requirements.txt
COPY . .
ENTRYPOINT ["python"]
EXPOSE 5000
CMD ["app.py"]