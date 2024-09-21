from flask import Flask, jsonify, request
import pyotp

app = Flask(__name__)

SECRET = 'JBSWY3DPEHPK3PXP'  # Consistent base32 secret

@app.route('/generate-otp', methods=['GET'])
def generate_otp():
    totp = pyotp.TOTP(SECRET)
    current_otp = totp.now()
    print(f'Generated OTP: {current_otp}')  # Print OTP to the terminal
    return jsonify({'otp': current_otp}), 200

@app.route('/validate-otp', methods=['POST'])
def validate_otp():
    data = request.get_json()
    entered_otp = data.get('otp')

    if not entered_otp:
        return jsonify({'error': 'No OTP provided'}), 400

    totp = pyotp.TOTP(SECRET)
    # Allow a small time window for verification
    if totp.verify(entered_otp, valid_window=1):
        print(f'Entered OTP: {entered_otp} is VALID')
        return jsonify({'success': True, 'message': 'OTP is valid!'}), 200
    else:
        print(f'Entered OTP: {entered_otp} is INVALID')
        return jsonify({'success': False, 'message': 'OTP is invalid!'}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5500, debug=True)
