# Fix for OpenSSL::Cipher::CipherError when setting additional authenticated data
# 
# Error: "couldn't set additional authenticated data (OpenSSL::Cipher::CipherError)"
# 
# This issue occurs when using ActiveSupport::MessageEncryptor with certain OpenSSL versions.
# The fix ensures the cipher IV is set before attempting to set AAD, which is required
# for proper initialization in GCM mode.
# 
# If this fix doesn't work, you may need to:
# 1. Update OpenSSL to a compatible version
# 2. Use a Ruby version manager (rbenv/rvm) with proper OpenSSL linking
# 3. Configure MessageEncryptor to use a non-GCM cipher (not recommended for security)

module MessageEncryptorFix
  private

  def _encrypt(value)
    cipher = new_cipher
    cipher.encrypt
    cipher.key = @secret

    # Generate and set IV before setting AAD
    # Some OpenSSL versions require this specific order
    iv = cipher.random_iv
    cipher.iv = iv

    # Set AAD after IV is set (required for GCM mode)
    if @cipher && @cipher.include?('GCM')
      aad = @serializer ? "messageencryptor-aad-#{@serializer}" : "messageencryptor-aad"
      begin
        cipher.auth_data = aad
      rescue OpenSSL::Cipher::CipherError
        # Retry with a fresh cipher if AAD setting fails
        cipher = new_cipher
        cipher.encrypt
        cipher.key = @secret
        cipher.iv = iv
        cipher.auth_data = aad
      end
    end

    encrypted_data = cipher.update(value)
    encrypted_data << cipher.final

    blob = "#{::Base64.strict_encode64 encrypted_data}--#{::Base64.strict_encode64 iv}"
    blob = "#{blob}--#{::Base64.strict_encode64 cipher.auth_tag}" if @cipher && @cipher.include?('GCM')
    blob
  end
end

ActiveSupport::MessageEncryptor.prepend(MessageEncryptorFix)

