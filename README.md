
Descrição
Limpa os arquivos de qualquer pasta do windows.

Benefícios:

1. Libera espaço em disco.
2. Melhora o desempenho do sistema
3. Ajuda a prevenir problemas de segurança

Instruções de Permissão:

1. Abra o PowerShell como administrador.
2. Execute o seguinte comando: Set-ExecutionPolicy Unrestricted
3. Pressione Enter para confirmar.
4. Reinicie o PowerShell.

Instruções de uso:

1. Abra um prompt de comando ou PowerShell.
2. Navegue até o diretório onde o script está localizado.
3. Execute o script com o seguinte comando: .\multipath.ps1 (exemplo para o arquivo multipath.ps1)

Instruções execução Zabbix como UserParameter:
1. Crie um item dentro do host, do tipo zabbix agent (ativo ou passivo), com tipo de informação log ou texto e passe uma chave.
2. Salve o script em algum diretório no Windows (host).
3. No arquivo de configuração do Zabbix, no campo UserParameter, passe dessa forma: UserParameter=nome-chave,powershell.exe -NoLogo -NoProfile -Noninteractive -ExecutionPolicy Bypass -File C:\path\nome-arquivo.ps1
